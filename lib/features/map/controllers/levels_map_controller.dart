
import 'package:get/get.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../Models/Child.dart';
import '../../../Models/letters_seed.dart';

class LevelsMapController extends GetxController {
  final  data = Get.find<NamouFirebaseDataController>();

  // UI: which level is highlighted/open
  final RxnString selectedId = RxnString();

  // Convenient getters
  String? get childId => data.selectedChildId.value;
  Child?  get child   => childId == null ? null : data.children[childId];

  // The sequence of levels (28 letters)
  List<LetterSeed> get letters => kLetterSeeds;

  // -------- Basic UI helpers (pure + tiny) --------

  /// Status of a letter for current child (first letter unlocked if nothing yet)
  LetterStatus statusOf(String letterId) {
    final c = child;
    if (c == null) {
      return letterId == letters.first.id ? LetterStatus.unlocked : LetterStatus.locked;
    }
    final lp = c.levels[letterId];
    return lp?.status ?? LetterStatus.locked;
  }

  /// Sum points (0..100) stored on the letter
  int pointsOf(String letterId) {
    final c = child;
    if (c == null) return 0;
    final lp = c.levels[letterId];
    return (lp?.points ?? 0).clamp(0, 100);
  }

  /// Quick helpers for UI
  bool isLocked(String letterId)   => statusOf(letterId) == LetterStatus.locked;
  bool isUnlocked(String letterId) => statusOf(letterId) == LetterStatus.unlocked;
  bool isPassed(String letterId)   => statusOf(letterId) == LetterStatus.passed;

  /// Overall progress (ratio of passed letters)
  double overallProgress() {
    final c = child;
    if (c == null || letters.isEmpty) return 0;
    final passed = letters.where((s) => c.levels[s.id]?.status == LetterStatus.passed).length;
    return passed / letters.length;
  }

  /// Select a level in UI
  void select(String letterId) => selectedId.value = letterId;


}
