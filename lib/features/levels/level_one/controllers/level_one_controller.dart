import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/services/audio_manager.dart';
import '../../../../services/google_stt_service.dart';
import '../../../../services/letter_tracing_service.dart';

import '../../../../services/text_to_speech_service.dart';

class LevelOneController extends GetxController with GetSingleTickerProviderStateMixin {
  final speechService = Get.find<TextToSpeechService>();
  final tracingService = Get.find<TracingService>();
  final stt =  Get.find<GoogleSpeechV2Service>();

  late AnimationController lottieController;

  // UI note
  final RxString noteText = ''.tr.obs;

  // ==== Tracing state ====
  final RxBool letterTracing = false.obs;      // show/hide tracing widget
  final RxDouble matchPercent = 0.0.obs;       // 0.0 .. 1.0
  final RxInt points = 0.obs;                  // awarded ONLY in onGameFinished
  // ==== Result state ====
  final RxBool isResult = false.obs;           // true => show your result widget
  final RxBool timedOut = false.obs;           // true if timeout ended the round
  final RxBool passed = false.obs;             // success/fail for this round
  // ==== Countdown ====
  final RxInt secondsLeft = 10.obs;
  Timer? _countdown;

  // add near other fields
  final RxInt currentCharCount = 1.obs; // how many letters in this round
  final int pointsPerChar = 12;         // <- your scoring rule

  @override
  void onInit() {
    super.onInit();
   // lottieController = AnimationController(vsync: this);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await Future.delayed(const Duration(seconds: 1));
    await speekHello();
  }

  Future<void> speekHello() async {
    // resetCharacter();
    // playCharacter();
    noteText.value = 'level1.pronounce.step1'.tr;
    await speechService.speak('level1.pronounce.step1'.tr);
    await Future.delayed(const Duration(seconds: 2));
    // stopCharacter();
    // resetCharacter();
    startPronounceSequence();
  }

  void startPronounceSequence() async {
    // resetCharacter();
    // playCharacter();

    noteText.value = 'level1.pronounce.step2'.tr;
    await speechService.speak('level1.pronounce.step2'.tr);
    await Future.delayed(const Duration(seconds: 1));

    noteText.value = 'level1.pronounce.repeat'.tr;
    await speechService.speak('level1.pronounce.repeat'.tr);
    await Future.delayed(const Duration(seconds: 1));

    noteText.value = 'level1.pronounce.instruction'.tr;
    await speechService.speak('level1.pronounce.instruction'.tr);
    await Future.delayed(const Duration(seconds: 1));

    noteText.value = 'level1.pronounce.listening'.tr;
    await speechService.speak('level1.pronounce.listening'.tr);

    // stopCharacter();
    // resetCharacter();
    Get.find<AudioManagerController>().toggleMusic();
// later:
     await Get.find<GoogleSpeechV2Service>().stop();


     final heard = await stt
         .listenKeyword('ألف', timeout: const Duration(seconds: 8));
     if (heard) {
       startAlifTracing();
       // ✅ target word detected
     } else {
       // ❌ not detected in time
     }
    Get.find<AudioManagerController>().toggleMusic();


  }

  // ==== Tracing control ====
  Future<void> startAlifTracing() async {
    _resetRoundState();
   // resetCharacter();
    currentCharCount.value = 1;   // only one letter in this round
    letterTracing.value = true;
    noteText.value = 'level1.tracing.start'.tr;
    await speechService.speak('level1.tracing.start'.tr);
    _startCountdown(20);
  }

  void onTracingUpdated(double progress01) {
    // progress in [0..1]
    matchPercent.value = progress01.clamp(0, 1);
  }

  // We IGNORE onCurrentTracingScreenFinished for single-char game.
  void onTracingCharFinished(double progress01) {
    // Some packages send 0 until the LAST stroke — that's fine.
    matchPercent.value = progress01.clamp(0, 1);
  }

  void onGameFinished(int i) {
    if (isResult.value) return; // guard against double fire
    _stopCountdown();

    final finishedInTime = !timedOut.value;
    passed.value = finishedInTime;

    if (finishedInTime) {
      // treat finish as 100% match for a single-character round
      matchPercent.value = 1.0;
      points.value = pointsPerChar * currentCharCount.value;// 12 * 1 = 12

      noteText.value = 'level1.great.write'.tr;
       speechService.speak('level1.great.write'.tr);
    } else {
      matchPercent.value = 0.0;
      points.value = 0;
      noteText.value = 'level1.bad.write'.tr;
      speechService.speak('level1.bad.write'.tr);
    }

    letterTracing.value = false;
    isResult.value = true;
  }

  // ==== Timer helpers ====


  void _onTimeout() {
    if (isResult.value) return; // if finished this tick, ignore timeout
    timedOut.value = true;
    letterTracing.value = false;
    passed.value = false;
    points.value = 0;
    matchPercent.value = 0.0;
    isResult.value = true;
    noteText.value = 'level1.bad.write'.tr;
    speechService.speak('level1.bad.write'.tr);
  }



  void _startCountdown(int seconds) {
    _stopCountdown();
    secondsLeft.value = seconds;
    timedOut.value = false;
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      secondsLeft.value -= 1;
      if (secondsLeft.value <= 0) {
        t.cancel();
        _onTimeout();
      }
    });
  }

  void _stopCountdown() { _countdown?.cancel(); _countdown = null; }

  void _resetRoundState() {
    isResult.value = false;
    timedOut.value = false;
    passed.value = false;
    points.value = 0;
    matchPercent.value = 0.0;
    _stopCountdown();
  }



  // Lottie helpers
  void playCharacter() => lottieController.repeat();
  void stopCharacter() => lottieController.stop();
  void resetCharacter() => lottieController.reset();

  @override
  void onClose() {
    _stopCountdown();
    lottieController.dispose();
    super.onClose();
  }
}
