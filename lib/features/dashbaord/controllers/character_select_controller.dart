import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../services/text_to_speech_service.dart';
import '../../../Models/characters.dart';

class CharacterSelectController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final data = Get.find<NamouFirebaseDataController>();
  final tts  = Get.find<TextToSpeechService>();

  late final PageController pageController;
  late final AnimationController lottieController;

  final RxInt currentIndex = 0.obs;
  late final List<CharacterPreset> items;

  Timer? _debounce;
  int _speakRun = 0;

  // ---- Animation helpers ----
  void playCharacter() {
    // If someone calls this before composition is ready, use a safe period.
    if (lottieController.duration == null) {
      lottieController.repeat(period: const Duration(milliseconds: 1200));
    } else {
      lottieController.repeat();
    }
  }
  void stopCharacter() => lottieController.stop();
  void resetCharacter() => lottieController.reset();

  @override
  void onInit() {
    super.onInit();

    // Give a small default duration so repeat() is always safe.
    lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    items = kCharacterPresets.values.toList(growable: false);

    final sid = data.selectedChildId.value;
    final currentKey = (sid != null) ? data.children[sid]?.character : null;
    int initial = (currentKey == null)
        ? 0
        : items.indexWhere((p) => p.key == currentKey);
    if (initial < 0) initial = 0;

    pageController = PageController(initialPage: initial);
    currentIndex.value = initial;

    // Speak once for the initial item (animation will start from onLoaded).
    _previewCurrentOnce();
  }

  // Call this from Lottie.onLoaded of the *visible* page.
  void onLottieLoadedFor(int pageIndex, Duration duration) {
    if (pageIndex != currentIndex.value) return; // ignore stale loads
    lottieController.duration = duration;
    lottieController
      ..reset()
      ..repeat(); // start loop now that real duration is known
  }

  void onPageChanged(int i) {
    currentIndex.value = i;

    // stop/clear any previous loop; the new page will start from onLoaded
    lottieController.stop();
    lottieController.reset();

    // small debounce so we don't spam TTS during quick swipes
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), _previewCurrentOnce);
  }

  void next() {
    if (currentIndex.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  void prev() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  // One-time intro: speak once, then stop animation.
  Future<void> _previewCurrentOnce() async {
    final run = ++_speakRun;
    final p = items[currentIndex.value];
    playCharacter();
    await tts.stop();
    await tts.applyCharacterPreset(p);
    await tts.speak('مرحبًا! أنا ${p.arName}. اخترني لأكون صديقك في التعلم.');

    // If user swiped during speak, don't touch the controller
    if (run != _speakRun) return;

    // Stop the loop right after speaking (let the character rest).
    lottieController.stop();
  }

  Future<void> save() async {
    final sid = data.selectedChildId.value;
    if (sid == null) return;
    final key = items[currentIndex.value].key;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.orange, strokeWidth: 5)),
      barrierDismissible: false,
    );
    try {
      await data.updateChildProfile(childId: sid, character: key);
      if (Get.isDialogOpen ?? false) Get.back();
      Get.back();
      Get.snackbar(
        'تم الحفظ',
        'تم اختيار الشخصية: ${items[currentIndex.value].arName}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        'خطأ',
        'تعذر حفظ الاختيار: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    stopCharacter();
    tts.stop();

    // Restore the saved voice (preview choice should not leak globally).
    final sid = data.selectedChildId.value;
    if (sid != null) {
      final savedKey = data.children[sid]?.character;
      if (savedKey != null && savedKey.isNotEmpty) {
        final preset = kCharacterPresets[savedKey];
        if (preset != null) {
          Future.microtask(() => tts.applyCharacterPreset(preset));
        }
      }
    }

    pageController.dispose();
    lottieController.dispose();
    super.onClose();
  }
}
