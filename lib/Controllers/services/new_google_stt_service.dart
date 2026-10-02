import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:google_speech/generated/google/protobuf/duration.pb.dart' as gp;
// google_speech v2
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/generated/google/cloud/speech/v2/cloud_speech.pb.dart'
    show
    ExplicitDecodingConfig,
    ExplicitDecodingConfig_AudioEncoding,
    StreamingRecognizeResponse,
    StreamingRecognitionFeatures,
    RecognitionFeatures,
    StreamingRecognitionFeatures_VoiceActivityTimeout;

class NewGoogleSpeechV2Service extends GetxService {
  NewGoogleSpeechV2Service({
    required this.serviceAccountAsset,
    required this.projectId,
    this.languageCode = 'ar-SA',
    this.sampleRateHz = 16000,
    this.model = RecognitionModelV2.long,
    this.enablePunctuation = false,
    this.enableInterimResults = true,
    this.location = 'global',
  });

  final String serviceAccountAsset;
  final String projectId;
  final String languageCode;
  final int sampleRateHz;
  final RecognitionModelV2 model;
  final bool enablePunctuation;
  final bool enableInterimResults;
  final String location;

  final AudioRecorder _recorder = AudioRecorder();
  SpeechToTextV2? _stt;

  StreamSubscription<StreamingRecognizeResponse>? _respSub;
  StreamSubscription<Uint8List>? _micSub;

  bool _initialized = false;
  bool _listening = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (_initialized) return;
    final json = await rootBundle.loadString(serviceAccountAsset);
    final sa = ServiceAccount.fromString(json);
    _stt = SpeechToTextV2.viaServiceAccount(sa, projectId: projectId);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized || _stt == null) {
      throw StateError('Call init() before using GoogleSpeechV2Service');
    }
  }

  RecognitionConfigV2 _buildConfigV2() {
    return RecognitionConfigV2(
      languageCodes: [languageCode],
      model: model,
      explicitDecodingConfig: ExplicitDecodingConfig(
        encoding: ExplicitDecodingConfig_AudioEncoding.LINEAR16,
        sampleRateHertz: sampleRateHz,
        audioChannelCount: 1,
      ),
      features: RecognitionFeatures(
        enableAutomaticPunctuation: enablePunctuation,
      ),
    );
  }

  /// Start live streaming mic → Google STT v2
  Future<void> startListening({
    required void Function(String text) onPartial,
    required void Function(String text) onFinal,
    void Function()? onDone,
    void Function(Object e, StackTrace st)? onError,
    // Optional: tweak endpointer behavior
    Duration speechStartTimeout = const Duration(seconds: 8),
    Duration speechEndTimeout = const Duration(seconds: 5),
    bool enableVAD = true,
  }) async
  {
    _ensureInitialized();
    if (_listening) {
      await stop();
    }

    if (!await _recorder.hasPermission()) {
      debugPrint('microphone permission not granted');
      throw Exception('Microphone permission not granted');
    }

    final streamingCfg = StreamingRecognitionConfigV2(
      config: _buildConfigV2(),
      streamingFeatures: StreamingRecognitionFeatures(
        interimResults: enableInterimResults,
        enableVoiceActivityEvents: enableVAD,
        // If you don’t want VAD control, pass enableVAD=false above.
        voiceActivityTimeout: enableVAD
            ? StreamingRecognitionFeatures_VoiceActivityTimeout(
          speechStartTimeout: gp.Duration()..seconds = $fixnum.Int64((speechStartTimeout.inSeconds)),
          speechEndTimeout: gp.Duration()..seconds = $fixnum.Int64((speechEndTimeout.inSeconds)),
        )
            : null,
      ),
    );

    final cfg = RecordConfig(
      encoder: AudioEncoder.pcm16bits, // LINEAR16
      sampleRate: sampleRateHz,
      numChannels: 1,
    );

    final micStream = await _recorder.startStream(cfg);
    // Keep the subscription if you want to be able to cancel explicitly later


    // google_speech expects Stream<List<int>>
    final audioStream = micStream.map<List<int>>((Uint8List chunk) => chunk);

    final responses = _stt!.streamingRecognize(streamingCfg, audioStream);

    _respSub = responses.listen(
          (resp) {
        for (final result in resp.results) {
          if (result.alternatives.isEmpty) continue;
          final text = result.alternatives.first.transcript ?? '';
          if (text.isEmpty) continue;
          if (result.isFinal) {
            onFinal(text);
          } else {
            onPartial(text);
          }
        }
      },
      onError: (e, st) {
        debugPrint('STT v2 error: $e');
        onError?.call(e, st);
      },
      onDone: () {
        _listening = false;
        onDone?.call();
      },
      cancelOnError: false,
    );

    _listening = true;
  }

  /// Stop streaming + cleanup
  Future<void> stop() async {
    if (_listening) {
      await _recorder.stop();
    }
    await _micSub?.cancel();
    _micSub = null;

    await _respSub?.cancel();
    _respSub = null;

    _listening = false;
  }

  /// Single keyword (existing behavior)
  Future<bool> listenKeyword(
      String keyword, {
        Duration timeout = const Duration(seconds: 8),
        bool caseInsensitive = false,
        bool normalizeArabic = true,
        bool requireWholeWord = false,
      }) async
  {
    return listenAnyKeyword(
      [keyword],
      timeout: timeout,
      caseInsensitive: caseInsensitive,
      normalizeArabic: normalizeArabic,
      requireWholeWord: requireWholeWord,
    );
  }

  // ========= NEW: MULTI-KEYWORD LISTENER =========
  /// Returns true as soon as ANY of the provided keywords is detected
  /// in partial or final hypotheses. Stops the stream when done or on timeout.
  Future<bool> listenAnyKeyword(
      List<String> keywords, {
        Duration timeout = const Duration(seconds: 8),
        bool caseInsensitive = false,
        bool normalizeArabic = true,
        bool requireWholeWord = false,
      }) async
  {
    _ensureInitialized();
    if (keywords.isEmpty || keywords.every((k) => k.trim().isEmpty)) {
      throw ArgumentError('keywords cannot be empty');
    }

    // Prepare target set
    final Set<String> targets = keywords
        .map((k) => _prep(k, caseInsensitive: caseInsensitive, normalizeArabic: normalizeArabic))
        .where((k) => k.isNotEmpty)
        .toSet();

    debugPrint('[STT] listenAnyKeyword start → ${targets.join(", ")}');

    final c = Completer<bool>();
    bool finished = false;

    bool tryFinish(bool v) {
      if (!finished && !c.isCompleted) {
        finished = true;
        c.complete(v);
        return true;
      }
      return false;
    }

    String prepText(String s) =>
        _prep(s, caseInsensitive: caseInsensitive, normalizeArabic: normalizeArabic);

    String? _match(String text) {
      if (text.isEmpty) return null;
      // Simple fast path
      for (final t in targets) {
        if (!requireWholeWord) {
          if (text.contains(t)) return t;
        } else {
          // Whole-word-ish for Arabic: use whitespace/punctuation boundaries.
          // \b isn't reliable for all scripts, so we approximate.
          final pattern = RegExp('(^|\\s|[.,;:!؟،/\\-_"\'()\\[\\]])${RegExp.escape(t)}(\\s|\$|[.,;:!؟،/\\-_"\'()\\[\\]])');
          if (pattern.hasMatch(text)) return t;
        }
      }
      return null;
    }

    await startListening(
      onPartial: (t) {
        final norm = prepText(t);
        final hit = _match(norm);
        if (hit != null) {
          debugPrint('[STT] ✅ HIT on partial: "$hit"');
          tryFinish(true);
            // stop will be called after the future completes below

        }{
          debugPrint('[STT] partial  $t');
        }
      },
      onFinal: (t) {
        final norm = prepText(t);
        final hit = _match(norm);
        if (hit != null) {
          debugPrint('[STT] ✅ HIT on final: "$hit"');
             tryFinish(true);
        } else {
          debugPrint('[STT] final without hit $t');
        }
      },
      onDone: () {

          debugPrint('[STT] stream done before hit — finishing false');
          tryFinish(false);

      },
      onError: (_, __) {
        tryFinish(false);
      },
      // Optional: tweak endpointer to auto-finalize on pauses
      speechStartTimeout: const Duration(seconds: 8),
      speechEndTimeout: const Duration(seconds: 2),
      enableVAD: false,
    );

    final timer = Timer(timeout, () {
      if (tryFinish(false)) {
        debugPrint('[STT] ⏱️ TIMEOUT (no hit)');
      }
    });

    final ok = await c.future;
    timer.cancel();
    await stop();
    debugPrint('[STT] listenAnyKeyword end → ${ok ? "HIT" : "MISS"}');
    return ok;
  }

  // ---------- helpers ----------
  String _prep(String s, {required bool caseInsensitive, required bool normalizeArabic}) {
    var t = s.trim();
    if (normalizeArabic) t = _normalizeArabic(t);
    if (caseInsensitive) t = t.toLowerCase();
    return t;
  }

  String _normalizeArabic(String s) {
    return s
        .replaceAll(RegExp('[\u064B-\u0652]'), '') // diacritics
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ء', '')
        .trim();
  }




  // final ok = await stt.listenAnyKeywordPhonetic(
  // ['مرحبا', 'مرحبة', 'أهلاً', 'اهلا', 'هلا'],
  // timeout: const Duration(seconds: 6),
  // maxDistance: 1,            // allow 1 edit
  // requireWholeWord: true,    // optional
  // );

  // --- basic Arabic cleanup already close to yours ---
  String _cleanupArabic(String s) {
    // remove tatweel, punctuation-like chars; keep spaces for tokenizing
    final cleaned = s
        .replaceAll('\u0640', '') // tatweel
        .replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), ' ') // keep Arabic letters & space
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return _normalizeArabic(cleaned);
  }

// --- tokenize by whitespace after cleanup ---
  List<String> _tokensAr(String s) {
    final t = _cleanupArabic(s);
    if (t.isEmpty) return const [];
    return t.split(' ');
  }

// --- tiny O(n*m) Damerau–Levenshtein (good enough for single words) ---
  int _editDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final m = a.length, n = b.length;
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) dp[i][0] = i;
    for (var j = 0; j <= n; j++) dp[0][j] = j;

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,      // deletion
          dp[i][j - 1] + 1,      // insertion
          dp[i - 1][j - 1] + cost, // substitution
        ].reduce((x, y) => x < y ? x : y);

        if (i > 1 && j > 1 &&
            a.codeUnitAt(i - 1) == b.codeUnitAt(j - 2) &&
            a.codeUnitAt(i - 2) == b.codeUnitAt(j - 1)) {
          dp[i][j] = dp[i][j] < dp[i - 2][j - 2] + cost ? dp[i][j] : dp[i - 2][j - 2] + 1;
        }
      }
    }
    return dp[m][n];
  }

// --- super-light Arabic "phonetic" key ---
// normalize similar-sounding letters into buckets.
// (This is intentionally simple; tune as you see ASR outputs.)
  String _phoneticKeyAr(String s) {
    final src = _cleanupArabic(s);
    final buf = StringBuffer();
    for (final ch in src.characters) {
      switch (ch) {
      // merge hamza variants to nothing (ASR often drops them)
        case 'ء': case 'أ': case 'إ': case 'ؤ': case 'ئ': continue;
      // alifs & long vowels => A
        case 'ا': case 'آ': case 'ى': case 'ي': case 'و': buf.write('A'); break;
      // k & q together
        case 'ك': case 'ق': buf.write('K'); break;
      // t-family (t/ṭ/d/ḍ sound confusions)
        case 'ت': case 'ط': case 'د': case 'ض': buf.write('T'); break;
      // sibilants (s/th/z/ẓ/ṣ)
        case 'س': case 'ث': case 'ز': case 'ذ': case 'ص': case 'ظ': buf.write('S'); break;
      // h breathy
        case 'ه': case 'ح': buf.write('H'); break;
      // 'ain can vanish; map to A (vowel-like)
        case 'ع': buf.write('A'); break;
      // gh/kha → G
        case 'غ': case 'خ': buf.write('G'); break;
      // j/sh-ish → J  (tweak if you prefer 'ش' separate)
        case 'ج': case 'ش': buf.write('J'); break;
      // b/f/p/v
        case 'ب': buf.write('B'); break;
        case 'ف': buf.write('F'); break;
      // m/n/l/r common
        case 'م': buf.write('M'); break;
        case 'ن': buf.write('N'); break;
        case 'ل': buf.write('L'); break;
        case 'ر': buf.write('R'); break;
      // taa marbuta → H
        case 'ة': buf.write('H'); break;
        default:
        // keep other Arabic letters as-is (rare)
          buf.write(ch);
      }
    }
    // collapse repeats: AAA -> A
    final out = buf.toString().replaceAll(RegExp(r'(.)\1+'), r'$1');
    return out;
  }



  /// Returns true as soon as ANY keyword (or its phonetic) matches.
  /// - Exact/substring match on normalized text
  /// - OR per-token edit distance <= maxDistance
  /// - OR phonetic keys equal
  Future<bool> listenAnyKeywordPhonetic(
      List<String> keywords, {
        Duration timeout = const Duration(seconds: 8),
        int maxDistance = 1,                 // 1 edit usually enough
        bool requireWholeWord = false,       // set true if you want token-only matches
      }) async
  {
    _ensureInitialized();
    final targets = <String>{};
    final targetPhones = <String>{};

    for (final k in keywords) {
      final t = _cleanupArabic(k);
      if (t.isEmpty) continue;
      targets.add(t);
      targetPhones.add(_phoneticKeyAr(t));
    }

    bool _textHit(String text) {
      final norm = _cleanupArabic(text);
      if (norm.isEmpty) return false;

      // quick contains / equals
      for (final t in targets) {
        if (!requireWholeWord) {
          if (norm.contains(t)) return true;
        } else {
          final pattern = RegExp('(^|\\s)${RegExp.escape(t)}(\\s|\$)');
          if (pattern.hasMatch(norm)) return true;
        }
      }

      // token-level fuzzy OR phonetic
      final toks = _tokensAr(norm);
      for (final tok in toks) {
        final phone = _phoneticKeyAr(tok);
        if (targetPhones.contains(phone)) return true;

        for (final t in targets) {
          if (_editDistance(tok, t) <= maxDistance) return true;
        }
      }
      return false;
    }

    final c = Completer<bool>();
    bool done = false;
    bool _finish(bool v) {
      if (!done && !c.isCompleted) { done = true; c.complete(v); return true; }
      return false;
    }

    await startListening(
      onPartial: (t) {
        print(t);
        if (_textHit(t)) _finish(true); },
      onFinal:   (t) {
        print(t);
        if (_textHit(t)) _finish(true); },
      onDone:    () { _finish(false); },
      onError:   (_, __) { _finish(false); },
      // keep your VAD settings
      speechStartTimeout: const Duration(seconds: 8),
      speechEndTimeout: const Duration(seconds: 2),
      enableVAD: false,
    );

    final timer = Timer(timeout, () => _finish(false));
    final ok = await c.future;
    timer.cancel();
    await stop();
    return ok;
  }





  @override
  void onClose() {
    stop();
    _respSub?.cancel();
    super.onClose();
  }
}
