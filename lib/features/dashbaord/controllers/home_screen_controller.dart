import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../services/text_to_speech_service.dart';
import '../../../utiles/translations/arabic_voices.dart';
//
// class HomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
//   final TextToSpeechService speechService = Get.find<TextToSpeechService>();
//   final data = Get.find<NamouFirebaseDataController>();
//
//
//   // Observable text note
//   final RxString helloText = 'ready.title'.tr.obs;
//// ---- Animation (optional mascot)
//   late AnimationController lottieController;
//
//  @override
//   void onReady() {
//
//     _speakHelloForSelected();
//     super.onReady();
//   }
//
//
//
//   String _helloLine() {
//     final sid = data.selectedChildId.value;
//     final name = (sid != null) ? (data.children[sid]?.name ?? '') : '';
//
//     if (name.isEmpty) {
//       return 'ready.title.default'.tr;
//     }
//
//     final prefix = 'ready.title.prefix'.tr;   // "مرحباً"
//     final suffix = 'ready.title.suffix'.tr;   // "، هل أنت مستعد لتعلم حرف جديد اليوم؟"
//     // Link strings around the name:
//     return '$prefix $name$suffix';
//   }
//
//   String get currentChildAvatarAsset {
//     final sid = data.selectedChildId.value;
//     if (sid == null) return 'assets/images/app_bar_profile.png';
//
//     final child = data.children[sid];
//     final path = (child?.avatarPath ?? child?.avatarPath ?? '').toString().trim();
//     return path.isNotEmpty ? path : 'assets/images/app_bar_profile.png';
//   }
//   Future<void> _speakHelloForSelected() async {
//     final line = _helloLine();
//     helloText.value = line;
//     await speechService.stop();      // stop any prior TTS
//     await speechService.speak(helloText.value); // speak dynamic line
//   }
//
//  void stopMedia(){
//    speechService.stop();
//
//   }
//
// }
//
//
//
//

import '../../../Models/characters.dart';

class HomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final TextToSpeechService speechService = Get.find<TextToSpeechService>();
  final data = Get.find<NamouFirebaseDataController>();

  final RxString helloText = 'ready.title'.tr.obs;
// ---- Animation (optional mascot)
  late AnimationController lottieController;
  // Guard so we don’t call methods on a disposed controller.
  bool _isClosed = false;
@override
  void onInit() {
  lottieController = AnimationController(vsync: this);
    super.onInit();
  }
  @override
  void onReady() {
    _setupVoiceAndGreet();   // << apply voice preset first, then speak
    super.onReady();
  }

  Future<void> _setupVoiceAndGreet() async {
    await _applyCharacterVoiceForSelected();
    await _speakHelloForSelected();
  }

  Future<void> _applyCharacterVoiceForSelected() async {
    final sid = data.selectedChildId.value;
    if (sid == null) return;

    final key = data.children[sid]?.character;
    // fallback to a default if null/unknown
    final preset = (key != null && kCharacterPresets.containsKey(key))
        ? kCharacterPresets[key]!
        : kCharacterPresets['tom']!;

    // this calls your TextToSpeechService.applyCharacterPreset(...)
    await speechService.applyCharacterPreset(preset);
  }

  String _helloLine() {
    final sid = data.selectedChildId.value;
    final name = (sid != null) ? (data.children[sid]?.name ?? '') : '';
    if (name.isEmpty) return 'ready.title.default'.tr;

    final prefix = 'ready.title.prefix'.tr;
    final suffix = 'ready.title.suffix'.tr;
    return '$prefix $name$suffix';
  }

  Future<void> _speakHelloForSelected() async {
    final line = _helloLine();
    helloText.value = line;
    playCharacter();
    await speechService.stop();
    await speechService.speak(helloText.value);
    stopCharacter();
  }

  void stopMedia() { speechService.stop();
  stopCharacter();
}

  String get currentChildAvatarAsset {
    final sid = data.selectedChildId.value;
    if (sid == null) return 'assets/images/app_bar_profile.png';
    final child = data.children[sid];
    final path = (child?.avatarPath ?? '').trim();
    return path.isNotEmpty ? path : 'assets/images/app_bar_profile.png';
  }

  void playCharacter() {
    if (_isClosed) return;
    // If someone calls this before composition is ready, use a safe period.
    if (lottieController.duration == null) {
      lottieController.repeat(period: const Duration(milliseconds: 5000));
    } else {
      lottieController.repeat();
    }
  }
  void stopCharacter() {
    if (_isClosed) return;
    try {
      lottieController.stop();
    } catch (_) {
      // ignore if already disposed
    }
  }

  void resetCharacter() {
    if (_isClosed) return;
    try {
      lottieController.reset();
    } catch (_) {}
  }

  @override
  void onClose() {
    // Mark closed first so late futures don’t touch the controller.
    _isClosed = true;

    // IMPORTANT: stop & dispose the AnimationController BEFORE calling super.onClose()
    try {
      lottieController.stop();
    } catch (_) {}
    try {
      lottieController.dispose();
    } catch (_) {}

    // Stop audio too
    speechService.stop();

    super.onClose();
  }

}
