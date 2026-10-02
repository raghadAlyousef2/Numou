import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:numou/features/authentication/controllers/auth_controller.dart';
import 'package:tracing_game/tracing_game.dart';
import '../../../../utiles/Widgets/arabic_progress_bar.dart';
import '../controllers/level_one_controller.dart';
class LevelOneScreen extends StatelessWidget {
  final controller = Get.put(LevelOneController());
  LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                  onPressed: () => print("Button 1"),
                  icon: Image.asset(
                    'assets/images/app_bar_home.png',
                    width: size.width * 0.05,
                    height: size.height * 0.05,
                  ),
                ),
                IconButton(
                  onPressed: () => print("Button 2"),
                  icon: Image.asset(
                    'assets/images/app_bar_profile.png',
                    width: size.width * 0.05,
                    height: size.height * 0.05,
                  ),
                ),
                IconButton(
                  onPressed: () => print("Button 3"),
                  icon: Image.asset(
                    'assets/images/app_bar_badge.png',
                    width: size.width * 0.05,
                    height: size.height * 0.05,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Get.find<AuthController>(
                ).logOut(),
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
            // Background image
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
                      ArabicProgressBar(
                        progressValue: 0.3,
                        levelText: 'ready.level.beginner',
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
                            Get.back();
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
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                    child: // level_one_screen.dart (inside the big Container that currently checks controller.letterTracing.value)
                    Obx(() {
                      if (controller.isResult.value) {
                        // Show YOUR result widget here (or a simple placeholder)
                        // You already have points, passed, timedOut, matchPercent.
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              mainAxisAlignment: controller.points.value!=0?MainAxisAlignment.end: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [

                                    Image.asset(
                                      'assets/images/level1_result_icon.png',
                                      height: size.height * 0.10,
                                      width: size.width * 0.2,
                                      fit: BoxFit.fill,
                                    ),
                                    Text(
                                      ' ${controller.points.value}',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 183, 37, 1),
                                        fontSize: size.width * 0.18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                if(controller.points.value!=0)
                                Image.asset(
                                  'assets/images/level1_result_character.png',
                                  height: size.height * 0.20,
                                  width: size.width * 0.30,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            Text(
                              ' ${'level1.youGot'.tr} ${controller.points.value} ${'level1.points'.tr}',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 183, 37, 1),
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (controller.points.value == 12)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // Background color of the button
                                        borderRadius: BorderRadius.circular(12),
                                        // border: Border.all(
                                        //   color: Color(0xFFE5E5E5), // Border color
                                        //   width: 2, // Border thickness
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              0xFF58A700,
                                            ), // Shadow color
                                            spreadRadius: 0.0,
                                            blurRadius: 0.0,
                                            offset: Offset(
                                              0,
                                              4,
                                            ), // Only bottom shadow
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // go to lesson
                                          //Todo next page
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF58CC02),
                                          padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.01,
                                            horizontal: size.width * 0.04,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'level1.complete'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: size.width * 0.038,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (controller.points.value == 12)
                                    SizedBox(width: size.width * 0.00),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // Background color of the button
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color(0xFFE5E5E5),
                                        // Border color
                                        width: 2, // Border thickness
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFE5E5E5),
                                          // Shadow color
                                          spreadRadius: 0.1,
                                          blurRadius: 0.1,
                                          offset: Offset(
                                            0,
                                            1,
                                          ), // Only bottom shadow
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // e.g., start a new attempt
                                        controller.startAlifTracing();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        // Make transparent to show Container color
                                        shadowColor: Colors.transparent,
                                        // Disable default shadow
                                        padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.01,
                                          horizontal: size.width * 0.06,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'level1.repeat'.tr,
                                        style: TextStyle(
                                          fontSize: size.width * 0.038,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1CB0F6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return controller.letterTracing.value
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                SizedBox(
                                  height: size.height * 0.38,

                                  child: TracingCharsGame(
                                    showAnchor: true,
                                    traceShapeModel: [
                                      // just the letter Alif
                                      controller.tracingService.charsOneScreen([
                                        'أ',
                                      ]),
                                    ],
                                    // progress 0..1 (adjust if your package uses 0..100)
                                    onTracingUpdated: (progress) async {
                                      print(progress);
                                      controller.onTracingCharFinished(
                                        progress.toDouble(),
                                      );
                                    },
                                    onCurrentTracingScreenFinished:
                                        (screenIndex) async {
                                          // controller.currentCharCount(
                                          //   screenIndex,
                                          // );
                                        },
                                    onGameFinished: (i) async {
                                      print('finish $i');
                                      controller.onGameFinished(i);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/level_one_letter_alif.png',
                                  height: size.height * 0.2,
                                  width: size.width * 0.4,
                                ),

                                Image.asset(
                                  'assets/images/level_one_character_1.png',
                                  height: size.height * 0.2,
                                  width: size.width * 0.8,
                                ),
                              ],
                            );
                    }),
                  ),
                ),
                SizedBox(height: size.height * .015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // Left side: Text note and speaker button
                    Obx(
                      () => Container(
                        width: size.width * 0.4,
                        height: size.height * 0.3,

                        //padding: const EdgeInsets.all(8),
                        // margin: const EdgeInsets.all(8),
                        child: controller.isResult.value
                            ? controller.points.value != 12
                                  ? Image.asset(
                                      'assets/characters/level1_speaking_character_boy.png',
                                      height: size.height * 0.20,
                                      width: size.width * 0.8,
                                    )
                                  : Image.asset(
                                      'assets/characters/level1_speaking_character.png',
                                      height: size.height * 0.20,
                                      width: size.width * 0.8,
                                    )
                            : Image.asset(
                                'assets/characters/level1_speaking_character.png',
                                height: size.height * 0.20,
                                width: size.width * 0.8,
                              ),

                        /*Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: Lottie.asset(
                            'assets/characters/cute_tiger.json',

                            fit: BoxFit.fill,
                            controller: controller.lottieController,
                            onLoaded: (composition) {
                              controller.lottieController.duration =
                                  composition.duration;
                            },
                          ),
                        ),*/
                      ),
                    ),

                    Obx(
                      () => Container(
                        width: size.width * 0.45,
                        height: size.height * 0.17,
                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.noteText.value,
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            // const SizedBox(height: 20),
                            IconButton(
                              icon: const Icon(
                                Icons.volume_up,
                                size: 36,
                                color: Colors.green,
                              ),
                              onPressed: controller.isResult.value
                                  ? () {
                                      controller.startAlifTracing();
                                    }
                                  : controller.letterTracing.value
                                  ? controller.startAlifTracing
                                  : controller.startPronounceSequence,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right side: Tiger animation
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
