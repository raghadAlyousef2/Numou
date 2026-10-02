
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';

// google_speech v2
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/generated/google/cloud/speech/v2/cloud_speech.pb.dart'
    show ExplicitDecodingConfig, ExplicitDecodingConfig_AudioEncoding, StreamingRecognizeResponse, StreamingRecognitionFeatures, RecognitionFeatures;
/// ---------------------------------------------------------------------------
/// GoogleSpeechV2Service — QUICK USAGE
/// ---------------------------------------------------------------------------
/// 1) Register + init once (e.g., in main.dart)
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final stt = Get.put(GoogleSpeechV2Service(
///     serviceAccountAsset: 'assets/keys/your_service_account.json',
///     projectId: 'your-gcp-project-id',
///     languageCode: 'ar-SA',      // or 'ar-EG'
///     sampleRateHz: 16000,
///     location: 'asia-south1',    // optional, for lower latency
///   ));
///   await stt.init();
///   runApp(const MyApp());
/// }
///
/// 2) Start/Stop live listening with UI callbacks
///
/// await Get.find<GoogleSpeechV2Service>().startListening(
///   onPartial: (t) => setState(() => partialText = t), // live updates
///   onFinal:   (t) => setState(() => finalText = t),   // committed text
/// );
///
/// // later:
/// await Get.find<GoogleSpeechV2Service>().stop();
///
/// 3) One-shot keyword detection (e.g., child says "ألف" within 8s)
///
/// final heard = await Get.find<GoogleSpeechV2Service>()
///     .listenKeyword('ألف', timeout: const Duration(seconds: 8));
/// if (heard) {
///   // ✅ target word detected
/// } else {
///   // ❌ not detected in time
/// }
///
/// 4) Minimal widget example (buttons + labels)
///
/// ElevatedButton(
///   onPressed: () async {
///     await Get.find<GoogleSpeechV2Service>().startListening(
///       onPartial: (t) => setState(() => partialText = t),
///       onFinal:   (t) => setState(() => finalText = t),
///     );
///   },
///   child: const Text('Start'),
/// );
///
/// ElevatedButton(
///   onPressed: () => Get.find<GoogleSpeechV2Service>().stop(),
///   child: const Text('Stop'),
/// );
///
/// Text('Partial: $partialText');
/// Text('Final: $finalText');
///
/// Notes:
/// - Ensure Android mic permission in AndroidManifest and NSMicrophoneUsageDescription on iOS.
/// - Recorder/sample rate must match config: LINEAR16, 16kHz, mono.
/// - Keep your service-account JSON secure; prefer short-lived tokens in production.
/// ---------------------------------------------------------------------------

class GoogleSpeechV2Service extends GetxService {
  GoogleSpeechV2Service({
    required this.serviceAccountAsset,   // e.g. 'assets/keys/numou-sa.json'
    required this.projectId,             // your GCP project id
    this.languageCode = 'ar-SA',
    this.sampleRateHz = 16000,
    this.model = RecognitionModelV2.short,
    this.enablePunctuation = false,
    this.enableInterimResults = true,
    this.location = 'global',            // or 'asia-south1', etc.
  });

  final String serviceAccountAsset;
  final String projectId;
  final String languageCode;
  final int sampleRateHz;
  final RecognitionModelV2 model;
  final bool enablePunctuation;
  final bool enableInterimResults;
  final String location;

  // ✅ NEW record API
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
    //final sa= ServiceAccount.fromFile(file);

    _stt = SpeechToTextV2.viaServiceAccount(
      sa,
      projectId: projectId,

    );
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
        enableAutomaticPunctuation: false,
      ),
    );
  }

  /// Start live streaming mic → Google STT v2
  Future<void> startListening({
    required void Function(String text) onPartial,
    required void Function(String text) onFinal,
  }) async
  {
    _ensureInitialized();
    if (_listening) await stop();

    if (!await _recorder.hasPermission()) {
      print('microphone permission not granted');
      throw Exception('Microphone permission not granted');
    }

    // v2 streaming config
    final streamingCfg = StreamingRecognitionConfigV2(
      config: _buildConfigV2(),
      streamingFeatures: StreamingRecognitionFeatures(
        interimResults: enableInterimResults,
      ),
    );


    final cfg = RecordConfig(
      encoder: AudioEncoder.pcm16bits,   // LINEAR16
      sampleRate: sampleRateHz,         // 16000
      numChannels: 1,                   // mono
    );
    final micStream = await _recorder.startStream(cfg);

    // google_speech expects Stream<List<int>>
    final audioStream = micStream.map<List<int>>((Uint8List chunk) => chunk);

    final responses =
    _stt!.streamingRecognize(streamingCfg, audioStream, );

    _respSub = responses.listen((resp)
    {
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
    }, onError: (e, st)
    {
      debugPrint('STT v2 error: $e');
    }, onDone: ()
    {
      _listening = false;
    });

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


  Future<bool> listenKeyword(
      String keyword, {
        Duration timeout = const Duration(seconds: 8),
        bool caseInsensitive = false,
        bool normalizeArabic = true,
      }) async
  {
    _ensureInitialized();
    if (keyword.trim().isEmpty) {
      throw ArgumentError('keyword cannot be empty');
    }

    String target = keyword.trim();
    if (normalizeArabic) target = _normalizeArabic(target);
    if (caseInsensitive) target = target.toLowerCase();

    debugPrint('[STT] listenKeyword start → target="$target"');

    final c = Completer<bool>();
    Timer? timer;

    String prep(String s) {
      var t = s;
      if (normalizeArabic) t = _normalizeArabic(t);
      if (caseInsensitive) t = t.toLowerCase();
      return t;
    }

    await startListening(
      onPartial: (t) {
        final norm = prep(t);
        debugPrint('[STT] partial: $t');
        if (norm.contains(target) && !c.isCompleted) {
          debugPrint('[STT] ✅ HIT on partial');
          c.complete(true);
        }
      },
      onFinal: (t) {
        final norm = prep(t);
        debugPrint('[STT] final:   $t');
        if (norm.contains(target) && !c.isCompleted) {
          debugPrint('[STT] ✅ HIT on final');
          c.complete(true);
        }
      },
    );

    timer = Timer(timeout, () {
      if (!c.isCompleted) {
        debugPrint('[STT] ⏱️ TIMEOUT (no hit)');
        c.complete(false);
      }
    });

    final ok = await c.future;
    timer.cancel();
    await stop();

    debugPrint('[STT] listenKeyword end → ${ok ? "HIT" : "MISS"}');
    return ok;
  }

  String _normalizeArabic(String s) {
    return s
        .replaceAll(RegExp('[\u064B-\u0652]'), '') // remove diacritics
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ء', '')
        .trim();
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
