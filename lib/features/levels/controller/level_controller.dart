// lib/features/level/level_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:numou/services/text_to_speech_service.dart';
import 'package:numou/services/google_stt_service.dart';
import 'package:numou/services/letter_tracing_service.dart';
import 'package:numou/services/audio_manager.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';

// adjust path if needed
import '../../../Models/Child.dart';
import '../../../Models/letters_seed.dart';
import '../../../services/new_google_stt_service.dart';
import '../../map/controllers/levels_map_controller.dart';

enum LevelPart { letterPronunciation, wordPronunciation, tracing, quiz }

class LevelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ---- Services / other controllers
  final tts = Get.find<TextToSpeechService>();
  final stt = Get.find<NewGoogleSpeechV2Service>();
  final tracingService = Get.find<TracingService>();
  final music =Get.find<AudioManagerController>();
  final dataController = Get.find<NamouFirebaseDataController>();
  final map = Get.find<LevelsMapController>();

  // ---- Animation (optional mascot)
  late AnimationController lottieController;

  // ---- Flow / UI state
  final Rx<LevelPart> currentPart = LevelPart.letterPronunciation.obs;

  // Shared result state (per part)
  final RxString noteText = ''.obs;
  final RxBool isResult = false.obs;
  final RxBool passed = false.obs;
  final RxDouble confidence = 0.0.obs;

  // Tracing state
  final RxDouble matchPercent = 0.0.obs;
  final RxInt secondsLeft = 0.obs;
  Timer? _countdown;

  // ====================== DERIVED DATA ======================

  /// Currently selected child
  String? get _childId => dataController.selectedChildId.value;

  Child? get _child =>
      _childId == null ? null : dataController.children[_childId];

  /// Currently selected letter seed (fallback to first if null)
  LetterSeed? get _seed {
    final id =
        map.selectedId.value ??
        (kLetterSeeds.isNotEmpty ? kLetterSeeds.first.id : null);
    if (id == null) return null;
    try {
      return kLetterSeeds.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  String get _letterId => _seed?.id ?? '';

  String get _letterGlyph => _seed?.glyph ?? '';

  String get _pronWordAr => _seed?.pronunciationWord.ar ?? '';

  String _partKey(LevelPart p) {
    switch (p) {
      case LevelPart.letterPronunciation: return kPartLetterPronunciation;
      case LevelPart.wordPronunciation:   return kPartWordPronunciation;
      case LevelPart.tracing:             return kPartTracing;
      case LevelPart.quiz:                return kPartQuiz;
    }
  }

// ✅ Safe: returns true/false without crashes
  bool get isAlreadyPassed {
    final c   = _child;
    final lid = _letterId;
    if (c == null || lid.isEmpty) return false;

    final key  = _partKey(currentPart.value);
    final part = c.levels[lid]?.parts[key];
    final st   = part?.status;

    // Works whether status is an enum or a string
    if (st is PartStatus) return st == PartStatus.passed;
    if (st is String)     return st == 'passed';
    return false;
  }
  ////// overlaping managment

  int runId = 0;                  // increments for each new part
  bool _isDisposed = false;        // set true in onClose()
  int _newRun() => ++runId;       // start a new run
  bool _isStale(int run) => _isDisposed || run != runId;
  int _speechToken = 0;
  Future<void> speakWithCharacter(String text) async {
    final myToken = ++_speechToken;
    noteText.value = text;
    playCharacter();
    try {
      await tts.speak(text);               // may be interrupted by a newer call
    } finally {
      // Only the latest speech may stop the animation
      if (_isDisposed || _speechToken != myToken) return;
      stopCharacter();
    }
  }


  // =================== LIFECYCLE ===================

  @override
  void onInit() {

    lottieController = AnimationController(vsync: this);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await startLetterPronunciationPart();
  }

  @override
  void onClose() {
    _isDisposed = true;
    runId++;
    stopMedia();
    _stopCountdown();
    lottieController.dispose();
    super.onClose();
  }

  // =========================================================
  // ========== LETTER PRONUNCIATION (say the letter) =========


  Future<void> startLetterPronunciationPart() async {

    final run = _newRun();            // <<< capture this run
    stopMedia();
    _resetResult();

    currentPart.value = LevelPart.letterPronunciation;

    final letter = _letterGlyph;
    if (letter.isEmpty || _isStale(run)) return;

    noteText.value = letter;
   resetCharacter();
    await  speakWithCharacter(letter);
    if (_isStale(run)) {   stopCharacter(); return;}

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) { return;}
    final prompt = '${'level1.pronounce.repeat'.tr} $letter';
    noteText.value = prompt;
    await  speakWithCharacter(prompt);
    if (_isStale(run)) {   stopCharacter(); return;}

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) {  stopCharacter(); return;}

    noteText.value = 'level1.pronounce.instruction'.tr;

    await  speakWithCharacter('level1.pronounce.instruction'.tr);

    if (_isStale(run)) {   stopCharacter(); return;}

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) {  stopCharacter();  return;}

    noteText.value = 'level1.pronounce.listening'.tr;

    await  speakWithCharacter('level1.pronounce.listening'.tr);

    if (_isStale(run)) return;

    var heard = await _listenFor(
      letter,
      timeout: const Duration(seconds: 15),
    );
    if (_isStale(run)) return;

    final conf = heard ? 1.0 : 0.0;

    if (heard) {
       speakWithCharacter('level1.great.write'.tr);
    } else {
       speakWithCharacter('level.bad.letter.speak'.tr);
    }
    if (_isStale(run)) return;

    await _finishPart(
      partName: kPartLetterPronunciation,
      passed: heard,
      confidence: conf,
    );
  }

  // =========================================================
  // ========== WORD PRONUNCIATION (say a word) ===============
  Future<void> startWordPronunciationPart() async {
    final run = _newRun();
    stopMedia();
    _resetResult();
    currentPart.value = LevelPart.wordPronunciation;

    final wordAr = _pronWordAr;
    if (wordAr.isEmpty || _isStale(run)) return;

    noteText.value = wordAr;
    await  speakWithCharacter(wordAr);
    if (_isStale(run)) return;

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) return;

    final prompt = '${'level1.pronounce.repeat'.tr} $wordAr';
    noteText.value = prompt;
    //resetCharacter();
    await  speakWithCharacter(prompt);
    if (_isStale(run)) return;

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) return;

    noteText.value = 'level.pronounce.word.instruction'.tr;
    await  speakWithCharacter('level.pronounce.word.instruction'.tr);
    if (_isStale(run)) return;

    await Future.delayed(const Duration(seconds: 1));
    if (_isStale(run)) return;

    noteText.value = 'level1.pronounce.listening'.tr;
    await  speakWithCharacter('level1.pronounce.listening'.tr);
    if (_isStale(run)) return;

    final heard = await _listenFor(wordAr, timeout: const Duration(seconds: 15));
    if (_isStale(run)) return;

    final conf = heard ? 1.0 : 0.0;
    if (heard) {
      noteText.value = 'level1.great.write'.tr;
      speakWithCharacter('level1.great.write'.tr);
    } else {
      noteText.value = 'level.bad.pronounce.word'.tr;
      speakWithCharacter('level.bad.pronounce.word'.tr);
    }
    if (_isStale(run)) return;

    await _finishPart(
      partName: kPartWordPronunciation,
      passed: heard,
      confidence: conf,
    );
  }




  // =========================================================
  // ====================== TRACING PART =====================
  Future<void> startTracingPart() async {
    final run = _newRun();
    stopMedia();
    _resetResult();
    currentPart.value = LevelPart.tracing;

    matchPercent.value = 0.0;
    noteText.value = 'level1.tracing.start'.tr;
   resetCharacter();
    await  speakWithCharacter('level1.tracing.start'.tr);
    if (_isStale(run)) return;

    _startCountdown(20); // guarded inside
  }


  void onTracingUpdated(double progress01) {
    matchPercent.value = progress01.clamp(0.0, 1.0);
  }

  void onTracingCharFinished(double progress01) {
    matchPercent.value = progress01.clamp(0.0, 1.0);
  }

  Future<void> onGameFinished(int _ ) async {
    if (isResult.value) return;
    _stopCountdown();
    stopMedia();
    final conf = matchPercent.value=1.0;
    final ok = conf >= 0.7;

    noteText.value = 'level1.great.write'.tr;
    speakWithCharacter('level1.great.write'.tr);
    await _finishPart(partName: kPartTracing, passed: ok, confidence: conf);
  }

  void _onTracingTimeout() {
    if (isResult.value || _isDisposed) return;
    stopMedia();
    noteText.value = 'level1.bad.write'.tr;
    speakWithCharacter('level1.bad.write'.tr);
    _finishPart(partName: kPartTracing, passed: false, confidence: 0.0);
  }
  void _startCountdown(int seconds) {
    _stopCountdown();
    secondsLeft.value = seconds;
    final run = runId;   // capture current run
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isStale(run)) { t.cancel(); return; }
      secondsLeft.value--;
      if (secondsLeft.value <= 0) {
        t.cancel();
        if (!_isDisposed && !_isStale(run)) {
          _onTracingTimeout();
        }
      }
    });
  }

  void _stopCountdown() {
    _countdown?.cancel();
    _countdown = null;
  }

  // =========================================================
  // ======================== QUIZ PART ======================


// NEW: prompt text (left) and image options (right)
  final RxString quizPromptAr = ''.obs;
  final RxList<String> quizOptionAssets = <String>[].obs; // asset path OR emoji char
  final RxInt quizAnswerIndex = (-1).obs;                  // index into quizOptionAssets

  // transient drag state for stateless UI
  final Rxn<Offset> quizDragStart = Rxn<Offset>();
  final Rxn<Offset> quizDragNow = Rxn<Offset>();
  final RxMap<int, Offset> quizOptionCenters = <int, Offset>{}.obs;
  final Rxn<Offset> quizImageCenter = Rxn<Offset>();

  int _quizRunId = 0; // snapshot of the run that started the quiz


  void configureQuizWordToImages({
    required String promptAr,
    required List<String> optionAssets,
    required int answerIndex,
  })
  {
    quizPromptAr.value = promptAr;
    quizOptionAssets.assignAll(optionAssets);
    quizAnswerIndex.value = answerIndex;
  }

  void quizRegisterImageCenter(Offset c) => quizImageCenter.value = c;

  void quizRegisterOptionCenter(int i, Offset c) => quizOptionCenters[i] = c;

  void quizBeginDrag() {
    final c0 = quizImageCenter.value;
    quizDragStart.value = c0;
    quizDragNow.value = c0;
  }

  void quizUpdateDrag(Offset p) => quizDragNow.value = p;


  Future<void> quizEndDrag({double snapRadius = 90}) async {
    final now = quizDragNow.value;
    if (now == null) { quizClearDrag(); return; }

    int? bestIdx;
    double best = double.infinity;
    quizOptionCenters.forEach((i, center) {
      final d = (center - now).distance;
      if (d < best) { best = d; bestIdx = i; }
    });

    final idx = (best != double.infinity && best <= snapRadius) ? bestIdx : null;
    final isCorrect = idx != null && idx == quizAnswerIndex.value;

    quizClearDrag();
    await completeQuiz(isCorrect: isCorrect);
  }



  void quizClearDrag() {
    quizDragStart.value = null;
    quizDragNow.value = null;
  }



  Future<void> startQuizPart() async {
    final run = _newRun();
    _quizRunId = run;
    stopMedia();
    _resetResult();
    currentPart.value = LevelPart.quiz;

    final s = _seed;
    if (_isStale(run)) return;

    if (s != null) {
      final p = s.pronunciationWord;     // the prompt word (Arabic on left)
      final options = List<QuizItem>.from(s.quiz); // copy to be safe

      // Build (asset, ar) pairs so we can shuffle but still locate the correct one.
      final pairs = options.map((q) => {
        'asset': (q.imageAsset.isNotEmpty) ? q.emoji : q.emoji, // image path or emoji char use q.imageAsset if render image isntead of emoji
        'ar': q.ar,
      }).toList(growable: false);

      // Shuffle (random every time)
      final shuffled = List<Map<String, String>>.from(pairs)..shuffle(Random());

      // Extract assets in the new order
      final optionAssets = shuffled.map((e) => e['asset']!).toList(growable: false);

      // Find the correct index *after* shuffling by Arabic word
      int answerIndex = shuffled.indexWhere((e) => e['ar'] == p.ar);
      if (answerIndex < 0) answerIndex = 0; // defensive fallback

      // Configure for "word → image" quiz
      configureQuizWordToImages(
        promptAr: p.ar,
        optionAssets: optionAssets,
        answerIndex: answerIndex,
      );


    }
    if (_isStale(run)) return;

    noteText.value = "level.quiz.instruction".tr;
    resetCharacter();
   await  speakWithCharacter("level.quiz.instruction".tr);
  }

  Future<void> completeQuiz({
    required bool isCorrect,
    double confIfNeeded = 1.0,
  }) async
  {
    stopMedia();
    // Use the run that started this quiz; if a newer run exists, bail out.
    final run = _quizRunId;

    // If the controller is disposed, the run is stale, or we are no longer on the quiz part, do nothing.
    if (_isStale(run) || currentPart.value != LevelPart.quiz || isResult.value) {
      return;
    }

    if (isCorrect) {
      noteText.value = 'level.quiz.good'.tr;
      speakWithCharacter('level.quiz.good'.tr);
    } else {
      noteText.value = 'level.quiz.bad'.tr;
      speakWithCharacter('level.quiz.bad'.tr);
    }
    if (_isStale(run)) return;

    await _finishPart(
      partName: kPartQuiz,
      passed: isCorrect,
      confidence: isCorrect ? confIfNeeded : 0.0,
    );
  }


//////////////////////////////////
  Future<bool> _listenFor(
    String phrase, {
    Duration timeout = const Duration(seconds: 8),
  }) async
  {
    final audio = Get.find<AudioManagerController>();
    audio.toggleMusic();
    /*final heard = await stt.listenKeyword(
      phrase,
      timeout: timeout,
      caseInsensitive: false,
      normalizeArabic: true,
    );*/bool heard=false;

    if(_child?.difficulty=='سهل'){
       heard = await  stt.listenAnyKeywordPhonetic([phrase],maxDistance:  1,requireWholeWord: false,timeout: timeout);}
    else if(_child?.difficulty=='صعب'){
     heard = await stt.listenAnyKeyword([phrase],timeout:timeout );}
    else{
     List<String>? phrases= currentPart.value==LevelPart.letterPronunciation?  _seed?.letterAlts:_seed?.wordAlts;
     heard = await  stt.listenAnyKeyword([phrase, ...?phrases /*+hellping words*/ ]);

    }
    audio.toggleMusic();
    return heard;
  }

  Future<void> _finishPart({
    required String partName,
    required bool passed,
    required double confidence,
  }) async
  {
    if (_isDisposed) return;

    this.passed.value = passed;
    this.confidence.value = confidence;
    isResult.value = true;

    final cid = _childId;
    final lid = _letterId;
    if (cid == null || lid.isEmpty) return;

    await dataController.updatePartProgress(
      childId: cid,
      letterId: lid,
      partName: partName,
      passed: passed,
      confidence: confidence,
      points: passed?currentPart.value == LevelPart.tracing?4:0:0
    );
    if (_isDisposed) return;

    await _unlockNextIfPassed(lid);
  }

  LetterStatus? _letterStatus(String letterId) {
    final c = _child;
    if (c == null) return null;
    return c.levels[letterId]?.status;
  }

  Future<void> _unlockNextIfPassed(String letterId, {int retries = 4}) async {
    final cid = _childId;
    if (cid == null) return;

    // Wait briefly for the reactive child to reflect the latest DB write.
    LetterStatus? st = _letterStatus(letterId);
    for (int i = 0; i < retries && st != LetterStatus.passed; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      st = _letterStatus(letterId);
    }
    if (st != LetterStatus.passed) return;

    // Find next letter
    final idx = kLetterSeeds.indexWhere((e) => e.id == letterId);
    if (idx < 0 || idx + 1 >= kLetterSeeds.length) return;

    final nextId = kLetterSeeds[idx + 1].id;
    final next = _child?.levels[nextId];

    // If next missing or locked -> unlock
    if (next == null || next.status == LetterStatus.locked) {
      await dataController.unlockLevel(childId: cid, letterId: nextId);
    }
  }


  void _resetResult() {
    isResult.value = false;
    passed.value = false;
    confidence.value = 0.0;
    noteText.value = '';
  }


  void playCharacter() {
    // If someone calls this before composition is ready, use a safe period.
    if (lottieController.duration == null) {
      lottieController.repeat(period: const Duration(milliseconds: 5000));
    } else {
      lottieController.repeat();
    }
  }
  void stopCharacter() => lottieController.stop();

  void resetCharacter() => lottieController.reset();

  Future<void> stopMedia() async {
    try {
      await _cancelSpeech();
    } catch (_) {}
    try {
      await stt.stop();
    } catch (_) {}

  }
// 3) Add a helper to cancel any ongoing speech safely
  Future<void> _cancelSpeech() async {
    _speechToken++;            // invalidate any pending speakWithCharacter
    try { await tts.stop(); } catch (_) {}
  }

  // ---- Reactive progress for the currently selected letter ----
  int get letterPoints {
    final c = _child;
    final lid = _letterId;
    if (c == null || lid.isEmpty) return 0;
    return (c.levels[lid]?.points ?? 0).clamp(0, 4);
  }

  double get letterProgress => (letterPoints / 4);

}
