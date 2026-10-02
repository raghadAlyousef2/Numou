import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/appUser.dart';

import '../Models/Child.dart';

import '../Models/letters_seed.dart';
import '../utiles/Constant/helper_funciton.dart';
import '../utiles/Widgets/alert_messages_dailog.dart';

class NamouFirebaseDataController extends GetxController {

  final fb = FirebaseDatabase.instance.ref();
  final fb_auth.User? _fbUser = fb_auth.FirebaseAuth.instance.currentUser;
  final connectivityDuration = const Duration(seconds: 10);
  RxBool isOnline = true.obs; // Reactive variable to track connectivity status
  // Reactive state
  Rx<AppUser> appUser = AppUser(
    uid: '',
    role: UserRole.parent,
    name: '',
    email: '',
  ).obs;

  RxMap<String, Child> children = <String, Child>{}.obs;

  // currently selected child
  final RxnString selectedChildId = RxnString();

  void selectChild(String id) => selectedChildId.value = id;

  // Subscriptions (keep tiny)
  StreamSubscription<DatabaseEvent>? _userSub;
  final Map<String, StreamSubscription<DatabaseEvent>> _childSubs = {};

  String get uid {
    final u = _fbUser;
    if (u == null) throw Exception('Not signed in');
    return u.uid;
  }

  @override
  void onInit() {
    final connectedRef = fb.child(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
       markOnline();
        addListenerToUser(uid);
      }
      else
      {
        markOffline();
      }
    });
    super.onInit();

  }
  void markOnline(){
    isOnline.value = true;

    debugPrint(" firebase is Connected.");

    Get.snackbar(  'متصل', // Connected
        'أنت متصل الآن', // Online / You are now online
        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.green,
        colorText: Colors.white70,
        messageText: Text(
          'متصل بالإنترنت', // Online
          textDirection: TextDirection.rtl, // مهم للعربي

          style: TextStyle(color: Colors.black),
        ));
  }
   void markOffline(){
     isOnline.value = false;
     // debugPrint(" firebase is Not connected.");
     Get.snackbar(
       'لا يوجد اتصال بالإنترنت',        // No Internet
       'يرجى التحقق من الاتصال بالشبكة', // Check Your Connection Please
       icon: const Icon(Icons.close),
       isDismissible: true,
       duration: const Duration(seconds: 5),
       snackPosition: SnackPosition.TOP,
       messageText: const Text(
         'يرجى التحقق من الاتصال بالإنترنت',
         textDirection: TextDirection.rtl,
       ),
       margin: const EdgeInsets.only(bottom: 110),
     );
   }
  @override
  void onClose() {
    _userSub?.cancel();
    for (final s in _childSubs.values) { s.cancel(); }
    _childSubs.clear();
    super.onClose();
  }

  // ---------------- core: user listener ----------------
  Future<void> addListenerToUser(String userId) async {
    await _userSub?.cancel();

    try {
      final snapshot = await fb.child('users/$userId')
          .get()
          .timeout(connectivityDuration);
      if (!snapshot.exists || snapshot.value is! Map) return;
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog('Request timed out while loading your profile.');
      return;
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Error while loading your profile: $e');
      return;
    }

    _userSub = fb.child('users/$userId').onValue.listen((event) async {
      if (!event.snapshot.exists || event.snapshot.value is! Map) return;

      // Re-parse full user node
      final next = AppUser.fromJson(event.snapshot.value as Map, userId);
      appUser.value = next;
      // 🔹 Debug: print user
      if (kDebugMode) {
        print('🔥 User updated:\n$appUser');
      }
      // If parent: ensure children listeners match childIds
      if (next.role == UserRole.parent) {
        final desired = next.childIds.keys.toSet();
        await _syncChildListeners(desired);
      } else if (next.role == UserRole.child) {
        // Optional: mirror self as a "child"
        await _syncChildListeners({userId});
      }
    },
      onError: (e, st) {
        AlertMessagesDialog.errorMessageDialog('Live update error (users/$userId): $e');
      },

    );
  }

  // ---------------- core: child listeners ----------------
  // Future<void> _syncChildListeners(Set<String> desiredIds) async {
  //   // Remove obsolete listeners
  //   final remove = _childSubs.keys.toSet().difference(desiredIds);
  //   for (final id in remove) {
  //     await _childSubs[id]?.cancel();
  //     _childSubs.remove(id);
  //     children.remove(id);
  //   }
  //
  //   // Add listeners for new ids
  //   final add = desiredIds.difference(_childSubs.keys.toSet());
  //   for (final id in add) {
  //     _childSubs[id] =
  //         fb.child('children/$id').onValue.listen((event) {
  //           if (!event.snapshot.exists || event.snapshot.value is! Map) {
  //             children.remove(id);
  //             return;
  //           }
  //           // Re-parse full child node
  //           final st = Child.fromJson(event.snapshot.value as Map, id);
  //           children[id] = st;
  //
  //           // 🔹 Debug: print child update
  //           if (kDebugMode) {
  //             print('📘 child updated: $st');
  //           }
  //         });
  //
  //   }
  // }
  //
  //
  Future<void> _syncChildListeners(Set<String> desiredIds) async {
    // remove
    final remove = _childSubs.keys.toSet().difference(desiredIds);
    for (final id in remove) {
      await _childSubs[id]?.cancel();
      _childSubs.remove(id);
      children.remove(id);
    }

    // add
    final add = desiredIds.difference(_childSubs.keys.toSet());
    for (final id in add) {
      try {
        final snapshot = await fb.child('children/$id')
            .get()
            .timeout(connectivityDuration);
        if (!snapshot.exists || snapshot.value is! Map) {
          children.remove(id);
          continue;
        }
      } on TimeoutException {
        AlertMessagesDialog.errorMessageDialog('Request timed out while loading child data.');
        continue;
      } catch (e) {
        AlertMessagesDialog.errorMessageDialog('Error while loading child data: $e');
        continue;
      }

      _childSubs[id] = fb.child('children/$id').onValue.listen(
            (event) {
          if (!event.snapshot.exists || event.snapshot.value is! Map) {
            children.remove(id);
            return;
          }
          final st = Child.fromJson(event.snapshot.value as Map, id);
          children[id] = st;
        },
        onError: (e, st) {
          AlertMessagesDialog.errorMessageDialog('Live update error (children/$id): $e');
        },
      );
    }
  }

  //
  // Future<void> updateProfileImageUrl(String? imageUrl) async
  // {
  //   // user.update((userData) {
  //   //   userData?.profileImageUrl = imageUrl;
  //   // });
  //   // // real time database update url
  //   // await fb
  //   //     .child('users/${user.value.userId}')
  //   //     .update({'profileImageUrl': imageUrl});
  // }
  //
  Future<void> updateProfileImageUrl(String childId, String imageUrl) async {
    try {
      await fb.child('children/$childId')
          .update({'avatar': imageUrl})
          .timeout(connectivityDuration);
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog('Request timed out while updating profile image.');
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Error while updating profile image: $e');
    }
  }



  ////////////////////////


  /// Minimal defaults for a part node
  Map<String, dynamic> _emptyPart() => {
    'status': 'tried',
    'points': 0,
    'attempts': 0,
    'best_confidence': 0.0,
  };

  /// Minimal defaults for a letter/level node (new structure)
  Map<String, dynamic> _initialLevelNode() => {
    'status': 'unlocked',
    'points': 0,
    'attempts': 0,
    'best_confidence': 0.0,
    'last_attempt_at': ServerValue.timestamp,
    'parts': {
      'letter_pronunciation': _emptyPart(),
      'word_pronunciation': _emptyPart(),
      'tracing': _emptyPart(),
      'quiz': _emptyPart(),
    }
  };

  /// Unlocks the given [letterId] for [childId].
  /// If the level already exists, it does nothing (no overwrite).
  // Future<void> unlockLevel({
  //   required String childId,
  //   required String letterId,
  // }) async
  // {
  //   final ref = FirebaseDatabase.instance
  //       .ref('children/$childId/levels/$letterId');
  //
  //   final snap = await ref.get();
  //   if (snap.exists) {
  //     // already present — keep existing progress
  //     return;
  //   }
  //
  //   await ref.set(_initialLevelNode());
  // }
  Future<void> unlockLevel({
    required String childId,
    required String letterId,
  }) async
  {
    final ref = FirebaseDatabase.instance.ref('children/$childId/levels/$letterId');

    try {
      final snap = await ref.get().timeout(connectivityDuration);
      if (snap.exists) return;

      await ref.set(_initialLevelNode()).timeout(connectivityDuration);
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog('Request timed out while creating the level.');
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Error while creating the level: $e');
    }
  }


  //
  // Future<String> addChildUnderParent({
  //   required String childName,
  //   required String age,
  //   required String avatarPath,
  //
  // }) async
  // {
  //   final parent = FirebaseAuth.instance.currentUser;
  //   if (parent == null) {
  //     throw Exception('Not signed in.');
  //   }
  //
  //   // Ensure current user is a parent
  //   final userSnap = await FirebaseDatabase.instance.ref('users/${parent.uid}').get();
  //   if (!userSnap.exists || (userSnap.child('role').value != 'parent')) {
  //     throw Exception('Current user is not a parent.');
  //   }
  //
  //   // --- 1) Duplicate check (same parent + same name) -------------------------
  //   String normalize(String s) => s.trim().toLowerCase();
  //   final wanted = normalize(childName);
  //
  //   // Query all children for this parent (single query), then compare names locally
  //   final existingSnap = await FirebaseDatabase.instance
  //       .ref('children')
  //       .orderByChild('parentId')
  //       .equalTo(parent.uid)
  //       .get();
  //
  //   if (existingSnap.exists) {
  //     for (final c in existingSnap.children) {
  //       final nameVal = (c.child('name').value ?? '').toString();
  //       if (normalize(nameVal) == wanted) {
  //         throw 'يوجد طفل بنفس الاسم بالفعل.';
  //
  //       }
  //     }
  //   }
  //   // -------------------------------------------------------------------------
  //
  //   final childId = FirebaseDatabase.instance.ref('children').push().key!;
  //
  //   // Atomic multi-location update
  //   final Map<String, Object?> updates = {
  //     'children/$childId': {
  //       'name': childName,
  //       'age': int.tryParse(age) ?? 0,
  //       'parentId': parent.uid,
  //       'avatar': avatarPath,
  //       'difficulty':'سهل',
  //       'levels': {}, // levels are filled locally as child plays
  //     },
  //     'users/${parent.uid}/childIds/$childId': true,
  //   };
  //
  //   // Optional: loading dialog
  //   Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
  //
  //   try {
  //     await FirebaseDatabase.instance.ref().update(updates);
  //     await unlockLevel(childId: childId, letterId: 'alif');
  //     if (Get.isDialogOpen ?? false) Get.back();
  //     return childId;
  //   } catch (e) {
  //     if (Get.isDialogOpen ?? false) Get.back();
  //     AlertMessagesDialog.errorMessageDialog('Failed to add child: $e');
  //     rethrow;
  //   }
  // }
  //
  Future<String> addChildUnderParent({
    required String childName,
    required String age,
    required String avatarPath,
  }) async
  {
    final parent = FirebaseAuth.instance.currentUser;
    if (parent == null) throw Exception('Not signed in.');

    try {
      final userSnap = await FirebaseDatabase.instance
          .ref('users/${parent.uid}')
          .get()
          .timeout(connectivityDuration);
      if (!userSnap.exists || (userSnap.child('role').value != 'parent')) {
        throw Exception('Current user is not a parent.');
      }

      String normalize(String s) => s.trim().toLowerCase();
      final wanted = normalize(childName);

      final existingSnap = await FirebaseDatabase.instance
          .ref('children')
          .orderByChild('parentId')
          .equalTo(parent.uid)
          .get()
          .timeout(connectivityDuration);

      if (existingSnap.exists) {
        for (final c in existingSnap.children) {
          final nameVal = (c.child('name').value ?? '').toString();
          if (normalize(nameVal) == wanted) {
            throw 'يوجد طفل بنفس الاسم بالفعل.';
          }
        }
      }

      final childId = FirebaseDatabase.instance.ref('children').push().key!;
      final updates = {
        'children/$childId': {
          'name': childName,
          'age': int.tryParse(age) ?? 0,
          'parentId': parent.uid,
          'avatar': avatarPath,
          'difficulty': 'سهل',
          'levels': {},
        },
        'users/${parent.uid}/childIds/$childId': true,
      };

      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      await FirebaseDatabase.instance.ref()
          .update(updates)
          .timeout(connectivityDuration);

      await unlockLevel(childId: childId, letterId: 'alif');

      if (Get.isDialogOpen ?? false) Get.back();
      return childId;
    } on TimeoutException {
      if (Get.isDialogOpen ?? false) Get.back();
      AlertMessagesDialog.errorMessageDialog('Request timed out while creating the child.');
      rethrow;
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      AlertMessagesDialog.errorMessageDialog('Failed to add child: $e');
      rethrow;
    }
  }




  // Future<void> updatePartProgress({
  //   required String childId,
  //   required String letterId,
  //   required String partName, // letter_pronunciation, word_pronunciation, tracing, quiz
  //   required bool passed,
  //   required double confidence, // 0.0–1.0
  //   required int points
  // }) async
  // {
  //   final  maxPointsPerPart = points;
  //   final levelRef = fb.child('children/$childId/levels/$letterId');
  //   final partRef  = levelRef.child('parts/$partName');
  //
  //   // Ensure level node exists (no-op if it already does)
  //   final levelSnap = await levelRef.get();
  //   if (!levelSnap.exists) {
  //     await unlockLevel(childId: childId, letterId: letterId);
  //   }
  //
  //   // --- Read current part to apply improve-only semantics
  //   final partSnap = await partRef.get();
  //   final prev = (partSnap.value is Map) ? (partSnap.value as Map) : const {};
  //
  //   final prevStatus = (prev['status'] as String?) ?? 'tried';
  //   final prevPoints = (prev['points'] as num?)?.toInt() ?? 0;
  //   final prevBest   = (prev['best_confidence'] as num?)?.toDouble() ?? 0.0;
  //   final prevAttempts = (prev['attempts'] as num?)?.toInt() ?? 0;
  //
  //   // Improve-only updates
  //   final newStatus = (prevStatus == 'passed')
  //       ? 'passed'
  //       : (passed ? 'passed' : 'tried');
  //
  //   final newPoints = (prevPoints >= maxPointsPerPart)
  //       ? prevPoints
  //       : (passed ? max(prevPoints, maxPointsPerPart) : prevPoints); // don’t drop points on fail
  //
  //   final newBest = max(prevBest, confidence);
  //
  //   await partRef.update({
  //     'status': newStatus,
  //     'points': newPoints,                 // stays at best (0 or 25)
  //     'attempts': prevAttempts + 1,        // always increments
  //     'best_confidence': newBest,
  //   });
  //
  //   // --- Recompute aggregates from parts
  //   final partsSnap = await levelRef.child('parts').get();
  //
  //   int totalPoints = 0;
  //   double totalConf = 0.0;
  //   int partCount = 0;
  //   bool allPassed = true;
  //   bool anyPassed = false;
  //
  //   if (partsSnap.exists && partsSnap.value is Map) {
  //     final parts = partsSnap.value as Map;
  //     parts.forEach((_, v) {
  //       if (v is Map) {
  //         final pts = (v['points'] as num?)?.toInt() ?? 0;
  //         final conf = (v['best_confidence'] as num?)?.toDouble() ?? 0.0;
  //         final st = (v['status'] as String?) ?? 'tried';
  //
  //         totalPoints += pts;
  //         totalConf += conf;
  //         partCount++;
  //
  //         if (st != 'passed') allPassed = false;
  //         if (st == 'passed') anyPassed = true;
  //       }
  //     });
  //   }
  //
  //   final avgConf = partCount > 0 ? (totalConf / partCount) : newBest;
  //
  //   // Compute desired letter status
  //   String computedStatus;
  //   if (allPassed && partCount == 4) {
  //     computedStatus = 'passed';
  //   } else if (anyPassed) {
  //     computedStatus = 'unlocked';
  //   } else {
  //     computedStatus = 'locked';
  //   }
  //
  //   // Never regress letter status
  //   final prevLetterStatus = (levelSnap.child('status').value as String?) ?? 'unlocked';
  //   String finalStatus = computedStatus;
  //   if (prevLetterStatus == 'passed') {
  //     finalStatus = 'passed';
  //   } else if (prevLetterStatus == 'unlocked' && computedStatus == 'locked') {
  //     finalStatus = 'unlocked';
  //   }
  //
  //   await levelRef.update({
  //     'last_attempt_at': ServerValue.timestamp,
  //     'attempts': ServerValue.increment(1),
  //     'points': totalPoints,          // 0..100, sum of best per-part
  //     'best_confidence': avgConf,     // avg of best confidences
  //     'status': finalStatus,          // no regression
  //   });
  // }

  Future<void> updatePartProgress({
    required String childId,
    required String letterId,
    required String partName,
    required bool passed,
    required double confidence,
    required int points,
  }) async
  {
    final maxPointsPerPart = points;
    final levelRef = fb.child('children/$childId/levels/$letterId');
    final partRef  = levelRef.child('parts/$partName');

    try {
      final levelSnap = await levelRef.get().timeout(connectivityDuration);
      if (!levelSnap.exists) {
        await unlockLevel(childId: childId, letterId: letterId);
      }

      final partSnap = await partRef.get().timeout(connectivityDuration);

      final prev = (partSnap.value is Map) ? (partSnap.value as Map) : const {};
      final prevStatus   = (prev['status'] as String?) ?? 'tried';
      final prevPoints   = (prev['points'] as num?)?.toInt() ?? 0;
      final prevBest     = (prev['best_confidence'] as num?)?.toDouble() ?? 0.0;
      final prevAttempts = (prev['attempts'] as num?)?.toInt() ?? 0;

      final newStatus = (prevStatus == 'passed') ? 'passed' : (passed ? 'passed' : 'tried');
      final newPoints = (prevPoints >= maxPointsPerPart)
          ? prevPoints
          : (passed ? (prevPoints > maxPointsPerPart ? prevPoints : maxPointsPerPart) : prevPoints);
      final newBest   = max(prevBest, confidence);

      await partRef.update({
        'status': newStatus,
        'points': newPoints,
        'attempts': prevAttempts + 1,
        'best_confidence': newBest,
      }).timeout(connectivityDuration);

      final partsSnap = await levelRef.child('parts').get().timeout(connectivityDuration);

      int totalPoints = 0;
      double totalConf = 0.0;
      int partCount = 0;
      bool allPassed = true;
      bool anyPassed = false;

      if (partsSnap.exists && partsSnap.value is Map) {
        final parts = partsSnap.value as Map;
        parts.forEach((_, v) {
          if (v is Map) {
            final pts = (v['points'] as num?)?.toInt() ?? 0;
            final conf = (v['best_confidence'] as num?)?.toDouble() ?? 0.0;
            final st = (v['status'] as String?) ?? 'tried';

            totalPoints += pts;
            totalConf += conf;
            partCount++;

            if (st != 'passed') allPassed = false;
            if (st == 'passed') anyPassed = true;
          }
        });
      }

      final avgConf = partCount > 0 ? (totalConf / partCount) : newBest;
      final computedStatus = (allPassed && partCount == 4)
          ? 'passed'
          : (anyPassed ? 'unlocked' : 'locked');

      final prevLetterStatus = (levelSnap.child('status').value as String?) ?? 'unlocked';
      final String finalStatus = (prevLetterStatus == 'passed')
          ? 'passed'
          : (prevLetterStatus == 'unlocked' && computedStatus == 'locked')
          ? 'unlocked'
          : computedStatus;

      await levelRef.update({
        'last_attempt_at': ServerValue.timestamp,
        'attempts': ServerValue.increment(1),
        'points': totalPoints,
        'best_confidence': avgConf,
        'status': finalStatus,
      }).timeout(connectivityDuration);

      await checkAndUpdateChildBadge(childId);
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog('Request timed out while saving progress.');
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Error while saving progress: $e');
    }
  }




  // ===== Global progress over ALL letters (stages) =====
  int get totalStages => kLetterSeeds.length;   // 28 Arabic letters
  int get maxPointsPerStage => 4;               // 4 pts per letter
  int get totalPossiblePoints => totalStages * maxPointsPerStage; // 112

  /// Sum of per-letter points (each letter clamped to 0..4)
  int childEarnedPoints(String childId) {
    final child = children[childId];
    if (child == null) return 0;

    var sum = 0;
    for (final seed in kLetterSeeds) {
      final pts = (child.levels[seed.id]?.points ?? 0);
      // Safety: clamp each letter to 0..4
      sum += pts.clamp(0, maxPointsPerStage);
    }
    return sum;
  }

  /// 0..1 progress across ALL letters
  double childProgress01(String childId) {
    final total = totalPossiblePoints;
    if (total == 0) return 0.0;
    return childEarnedPoints(childId) / total;
  }

  /// Convenience getters for currently-selected child
  int get selectedChildPoints {
    final id = selectedChildId.value;
    return (id == null) ? 0 : childEarnedPoints(id);
  }

  double get selectedChildProgress01 {
    final id = selectedChildId.value;
    return (id == null) ? 0.0 : childProgress01(id);
  }


// ===== Update child profile (name / avatar) =====
//   Future<void> updateChildProfile({
//     required String childId,
//     String? name,
//     String? avatarAsset,
//     String? difficulty,
//     String? character,   // <— NEW
//     int age =0
//   }) async
//   {
//     final Map<String, Object?> updates = {};
//     if (name != null) updates['name'] = name;
//     if (avatarAsset != null) updates['avatar'] = avatarAsset;
//     if (difficulty != null) updates['difficulty'] = difficulty;
//     if (character != null) updates['character'] = character; // <— NEW
//
//
//     if (age !=0 ) updates['age']= age;
//
//
//     if (updates.isEmpty) return;
//
//     await fb.child('children/$childId').update(updates);
//
//     // keep local reactive cache in sync
//     final c = children[childId];
//     if (c != null) {
//       final next = c.copyWith(
//         name: name ?? c.name,
//         avatarPath: avatarAsset ?? c.avatarPath,
//         age: age!=0 ? age:c.age,
//           difficulty: difficulty?? c.difficulty,
//         character: character ?? c.character,  // <— NEW
//       );
//       children[childId] = next;
//     }
//   }

  Future<void> updateChildProfile({
    required String childId,
    String? name,
    String? avatarAsset,
    String? difficulty,
    String? character,
    int age = 0,
  }) async
  {
    final Map<String, Object?> updates = {};
    if (name != null) updates['name'] = name;
    if (avatarAsset != null) updates['avatar'] = avatarAsset;
    if (difficulty != null) updates['difficulty'] = difficulty;
    if (character != null) updates['character'] = character;
    if (age != 0) updates['age'] = age;
    if (updates.isEmpty) return;

    try {
      await fb.child('children/$childId').update(updates).timeout(connectivityDuration);
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog('Request timed out while saving profile changes.');
      return;
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog('Error while saving profile changes: $e');
      return;
    }

    final c = children[childId];
    if (c != null) {
      final next = c.copyWith(
        name: name ?? c.name,
        avatarPath: avatarAsset ?? c.avatarPath,
        age: age != 0 ? age : c.age,
        difficulty: difficulty ?? c.difficulty,
        character: character ?? c.character,
      );
      children[childId] = next;
    }
  }


  /// Small rank helper so we only celebrate when badge improves (optional)
  int _badgeRank(String title) {
    switch (title.trim()) {
      case 'مبتدئ':
        return 1;
      case 'خبير':
        return 2;
      case 'ماهر':
        return 3;
      case 'متميز':
        return 4;
      default:
        return 0;
    }
  }

  /// Check child points -> compute badge -> store under child profile
  /// and show popup ONLY if badge changed / improved.
  Future<void> checkAndUpdateChildBadge(String childId) async {
    // 1) Compute badge from current progress
    final pts   = childEarnedPoints(childId);
    final total = totalPossiblePoints;
    final newBadge = titleForPoints(pts, total); // '', 'مبتدئ', 'خبير', 'ماهر', 'متميز'

    // If no badge yet, nothing to save
    if (newBadge.isEmpty) return;

    // 2) Read current badge from Firebase under child's profile node
    final badgeRef = fb.child('children/$childId/badge_title');

    String oldBadge = '';
    try {
      final snap = await badgeRef.get().timeout(connectivityDuration);
      if (snap.exists && snap.value != null) {
        oldBadge = snap.value.toString();
      }
    } on TimeoutException {
      // don't block game – just warn parent in error dialog
      AlertMessagesDialog.errorMessageDialog(
        'Request timed out while checking badges.',
      );
      return;
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog(
        'Error while checking badges: $e',
      );
      return;
    }

    // 3) If no change → do nothing (no popup, no write)
    if (oldBadge == newBadge) return;

    // 4) Save new badge
    try {
      await badgeRef
          .set(newBadge)
          .timeout(connectivityDuration);
    } on TimeoutException {
      AlertMessagesDialog.errorMessageDialog(
        'Request timed out while saving badge.',
      );
      return;
    } catch (e) {
      AlertMessagesDialog.errorMessageDialog(
        'Error while saving badge: $e',
      );
      return;
    }

    // 5) Show popup ONE TIME when badge improved
// 5) Show popup ONE TIME when badge improved
    if (_badgeRank(newBadge) > _badgeRank(oldBadge)) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '🎉 شارة جديدة!',
            textDirection: TextDirection.rtl,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مبروك! حصل طفلك على شارة:',
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Text(
                '"$newBadge"',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'حسناً',
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }

  }

}
