import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../Models/characters.dart';
import '../../../services/lottie_cashe_service.dart';
import '../../../utiles/Widgets/arabic_progress_bar.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../dashbaord/screens/character_select_screen.dart';
import '../../dashbaord/screens/child_dashboard.dart';
import '../../map/controllers/levels_map_controller.dart';
import '../../../Models/letters_seed.dart';
import '../controller/level_controller.dart';
import '../widgets/Letter_pronunciation_view.dart';
import '../widgets/letter_tracing_view.dart';
import '../widgets/matching_quiz_view.dart';
import '../widgets/result_card.dart';
import '../widgets/word_pronunciation_view.dart';
class LevelScreen extends StatelessWidget {
  LevelScreen({super.key});

  // Put controller (assumes its dependencies are already in Get)
  final LevelController c = Get.put(LevelController());
  final LevelsMapController map = Get.find<LevelsMapController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // derive current glyph (no private members touched)
    final String glyph = (() {
      final id =
          map.selectedId.value ??
          (kLetterSeeds.isNotEmpty ? kLetterSeeds.first.id : null);
      if (id == null) return '';
      return kLetterSeeds.firstWhereOrNull((e) => e.id == id)?.glyph ?? '';
    })();

    return  PopScope<void>(
      // Block the automatic pop (hardware back / iOS swipe)
        canPop: false,

        // NEW API (use this, onPopInvoked is deprecated)
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return; // Someone already popped the route; do nothing.



          if (context.mounted) {
            c.stopMedia();
            Get.back(); // or: Navigator.of(context).pop();
            Get.delete<LevelController>();
            // Optional: ensure controller is destroyed immediately:
            // Get.delete<LevelController>();
          }
        },

     child:
     Obx(
             ()=> GrayscaleWidget(
             isGrayscale: !c.dataController.isOnline.value,
             isAbsorb: false,

             child:
     Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Extra space if needed
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.001,
          ),
          // Padding for whole AppBar
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.orange,
                width: 1,
              ), // Lower border
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            // Make AppBar transparent to show container color
            elevation: 0,
            // Remove shadow
            leadingWidth: size.width * 0.4,
            automaticallyImplyLeading: false,

            leading: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    c.stopMedia();
                    c.runId++;
                   Get.back();
                  },
                  icon: Image.asset(
                    'assets/images/app_bar_home.png',
                    width: size.width * 0.05,
                    height: size.height * 0.05,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    c.stopMedia();
                    c.runId++;// change the run id to avoid next part when we are on dashboard

                  await  Get.to(() => const ChildDashboardScreen());

                    switch (c.currentPart.value) {
                      case LevelPart.letterPronunciation:
                          c.startLetterPronunciationPart();
                        break;
                      case LevelPart.wordPronunciation:
                        c.startWordPronunciationPart();
                        break;
                      case LevelPart.tracing:
                        c.startTracingPart();
                        break;
                      case LevelPart.quiz:
                        c.startQuizPart();
                      // finished the level; pop or show a "level complete"
                        Get.back();
                        break;
                    }
                    }

                  ,
                  icon: Image.asset(
                    'assets/images/app_bar_profile.png',
                    width: size.width * 0.05,
                    height: size.height * 0.05,
                  ),
                ),
                IconButton(
                  onPressed: ()   async {
                    c.stopMedia();
                  c.runId++;
                  await  Get.to(() => CharacterSelectScreen());

                  switch (c.currentPart.value) {
                    case LevelPart.letterPronunciation:
                      c.startLetterPronunciationPart();
                      break;
                    case LevelPart.wordPronunciation:
                      c.startWordPronunciationPart();
                      break;
                    case LevelPart.tracing:
                      c.startTracingPart();
                      break;
                    case LevelPart.quiz:
                      c.startQuizPart();
                      // finished the level; pop or show a "level complete"
                      Get.back();
                      break;
                  }},
                  icon: Icon(Icons.accessibility, size: size.width * 0.06,color: Colors.orange, ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  c.stopMedia();
                  Get.find<AuthController>().logOut();
                },
                icon: Image.asset(
                  'assets/images/app_bar_logout.png',
                  width: size.width * 0.05,
                  height: size.height * 0.05,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/images/numou_logo.png',
                  width: size.width * 0.07,
                  height: size.height * 0.07,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            // your background asset if desired
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_screen_background.png',
                fit: BoxFit.fill,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => ArabicProgressBar(
                          // shows the *live* total points for the selected letter (0..100)
                          points: c.letterPoints,
                          // bar fill (0.0..1.0)
                          progressValue: c.letterProgress,
                          // keep your existing label (or compute a tier if you want)
                          levelText: 'ready.level.beginner',
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.07,
                          ),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: IconButton(
                          onPressed: () {
                            c.stopMedia();
                            Get.back();
                            Get.delete<LevelController>(); // optional hard delete; ensures onClose() now
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.005),
                // Main content
                Padding(
                  padding:  EdgeInsets.all(size.width*0.02),
                  child: Container(
                    padding:  EdgeInsets.all(size.width*0.01),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width*0.015),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          spreadRadius: 0.0,
                          blurRadius: 2,
                          offset: Offset(0, 5), // Only bottom shadow
                        ),
                      ],
                    ),
                    child: Obx(() {
                      // Result view has priority
                      if (c.isResult.value) {
                        return ResultCard(
                          isPointsShow: c.currentPart.value==LevelPart.tracing,
                          passed: c.passed.value,
                          alreadyPassed: c.isAlreadyPassed ,
                          confidence: c.confidence.value,

                          onRepeat: () {
                            // repeat current part
                            switch (c.currentPart.value) {
                              case LevelPart.letterPronunciation:
                                c.startLetterPronunciationPart();
                                break;
                              case LevelPart.wordPronunciation:
                                c.startWordPronunciationPart();
                                break;
                              case LevelPart.tracing:
                                c.startTracingPart();
                                break;
                              case LevelPart.quiz:
                                c.startQuizPart();
                                break;
                            }
                          },
                          onNext: () {
                            // go to next part in the sequence
                            switch (c.currentPart.value) {
                              case LevelPart.letterPronunciation:
                                c.startWordPronunciationPart();
                                break;
                              case LevelPart.wordPronunciation:
                                c.startTracingPart();
                                break;
                              case LevelPart.tracing:
                                c.startQuizPart();
                                break;
                              case LevelPart.quiz:
                                // finished the level; pop or show a "level complete"
                                Get.back();
                                break;
                            }
                          },
                        );
                      }

                      // Live part view
                      switch (c.currentPart.value) {
                        case LevelPart.letterPronunciation:
                          return LetterPronunciationView(
                            glyph: glyph,
                            onRetry: c.startLetterPronunciationPart,
                          );

                        case LevelPart.wordPronunciation:
                          final word =
                              kLetterSeeds
                                  .firstWhereOrNull(
                                    (e) => e.id == (map.selectedId.value ?? ''),
                                  )
                                  ?.pronunciationWord
                                  .ar ??
                              '';
                          final imagePath =
                              kLetterSeeds
                                  .firstWhereOrNull(
                                    (e) => e.id == (map.selectedId.value ?? ''),
                              )
                                  ?.character.asset ??
                                  '';
                          final icon =
                              kLetterSeeds
                                  .firstWhereOrNull(
                                    (e) => e.id == (map.selectedId.value ?? ''),
                              )
                                  ?.pronunciationWord.emoji ??
                                  '';

                          return WordPronunciationView(
                            glyph: glyph,
                            word: word,
                            onRetry: c.startWordPronunciationPart,
                            imagePath: imagePath,
                            textIcon:icon,
                          );

                        case LevelPart.tracing:
                          return TracingView(
                            gglyph: glyph.isEmpty ? 'أ' : glyph,
                            // fallback just in case
                            onTracingUpdated: (p) =>
                                c.onTracingUpdated(p.toDouble()),
                            onFinished: (i) => c.onGameFinished(i),
                            secondsLeft: c.secondsLeft,
                            startCountdownIfNeeded: () {
                              // countdown is started inside controller.startTracingPart()
                            },
                          );

                        case LevelPart.quiz:
                          return MatchingQuizView();
                      }
                    }),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left side: Text note and speaker button
                  // REPLACE the Image.asset(...) block with:
                  Obx(() {
                    final data = Get.find<NamouFirebaseDataController>();
                    final cacheC  = Get.find<LottieCacheService>();     // <- your cache
                    final id   = data.selectedChildId.value;
                    final key  = (id == null) ? null : data.children[id]?.character;
                    final preset = (key != null && kCharacterPresets.containsKey(key))
                        ? kCharacterPresets[key]!
                        : kCharacterPresets['tom']!; // fallback
                    final comp = cacheC.get(preset.lottieAsset);        // <- try cache first
                    return SizedBox(
                      width: size.width * 0.35,
                      height: size.height * 0.23,
                   // child:   (comp != null)
                   //        ? Lottie(                                      // use cached
                   //      composition: comp,
                   //   controller: c.lottieController
                   //     ..duration = comp.duration,   // ← set here
                   //      fit: BoxFit.fill,
                   //     // onLoaded: (lc) => c.lottieController.duration = lc.duration,
                   //    )
                   //        : Lottie.asset(                                 // first load → cache it
                   //      preset.lottieAsset,
                   //      controller: c.lottieController,
                   //      fit: BoxFit.fill,
                   //      onLoaded: (lc) {
                   //        c.lottieController.duration = lc.duration;
                   //        cacheC.put(preset.lottieAsset, lc);
                   //        // save for next time
                   //      },
                   //    ),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          ),
                          child:Lottie.asset(
                          preset.lottieAsset,
                          controller: c.lottieController,
                          fit: BoxFit.fill,
                          onLoaded: (comp) {
                            c.lottieController.duration = comp.duration
                            ;
                          },
                        ),),
                    );
                  }),

                  // Obx(
                  //   () => SizedBox(
                  //     width: size.width * 0.4,
                  //     height: size.height * 0.3,
                  //
                  //     child: c.isResult.value
                  //         ? c.passed.value == false
                  //               ? Image.asset(
                  //                   'assets/characters/level1_speaking_character_boy.png',
                  //                   height: size.height * 0.20,
                  //                   width: size.width * 0.8,
                  //                 )
                  //               : Image.asset(
                  //                   'assets/characters/level1_speaking_character.png',
                  //                   height: size.height * 0.20,
                  //                   width: size.width * 0.8,
                  //                 )
                  //         : Image.asset(
                  //             'assets/characters/level1_speaking_character.png',
                  //             height: size.height * 0.20,
                  //             width: size.width * 0.8,
                  //           ),
                  //   ),
                  // ),

                  SizedBox(width: size.width*.01,),
                  Obx(
                    () => Container(
                      width: size.width * 0.45,
                      height: size.height * 0.12,
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.noteText.value,
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          // const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Right side: Tiger animation
                ],
              ),
            ),
          ],
        ),
      ),
     ))) ,);
  }
}


