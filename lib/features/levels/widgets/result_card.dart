import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Result card that mirrors the previous level-1 UI:
/// - Left: result icon + BIG points number
/// - Right (if points > 0): character image
/// - Below: "you got X points" text
/// - Buttons: "Complete" (only when full score) + "Repeat"
///
/// Logic stays the same as your existing ResultCard:
///   - `passed` & `confidence` drive the display
///   - `onRepeat` and `onNext` are callbacks
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.passed,
    required this.alreadyPassed,
    required this.confidence, // 0..1
    required this.onRepeat,
    required this.onNext,
    this.maxPoints = 4, // keep old UI’s 12-pt scale
    this.iconAsset = 'assets/images/level1_result_icon.png',
    this.characterAsset = 'assets/images/level1_result_character.png',
    required this.isPointsShow,
  });

  final bool passed;
  final bool alreadyPassed;
  final bool isPointsShow;
  final double confidence;
  final VoidCallback onRepeat;
  final VoidCallback onNext;

  /// How many points correspond to 100% confidence in this card
  final int maxPoints;

  /// UI assets (same as your previous screen)
  final String iconAsset;
  final String characterAsset;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Convert confidence (0..1) -> points (0..maxPoints)
    final int points = ((confidence.clamp(0.0, 1.0)) * maxPoints).round();

    final yellow = const Color.fromRGBO(255, 183, 37, 1); // #FFB725
    final green = const Color(0xFF58CC02);
    final greenShadow = const Color(0xFF58A700);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: result icon + BIG number, and the character on the side if points > 0
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: points != 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            children: [

              isPointsShow?
              Column(
                children: [
                  Image.asset(
                          iconAsset,
                          height: size.height * 0.10,
                          width: size.width * 0.18,
                          fit: BoxFit.fill,
                        ),
                  Text(
                    ' $points',
                    style: TextStyle(
                      color: yellow,
                      fontSize: size.width * 0.16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
              :
              Column(
                children: [
                  passed?
                  Image.asset(
                    iconAsset,
                    height: size.height * 0.10,
                    width: size.width * 0.18,
                    fit: BoxFit.fill,
                  ): Image.asset(
                    'assets/cross.png',
                    height: size.height * 0.10,
                    width: size.width * 0.19,
                    fit: BoxFit.fill,
                  ),

                ],
              )
              ,
               if(passed)
                Image.asset(
                  characterAsset,
                  height: size.height * 0.20,
                  width: size.width * 0.30,
                  fit: BoxFit.fill,
                )
            ],
          ),

          // "you got X points" line (uses your GetX translations)
          isPointsShow
              ? Text(
                  ' ${'level1.youGot'.tr} $points ${'level1.points'.tr}',
                  style: TextStyle(
                    color: yellow,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  passed != true
                      ? 'level.part.failThisPart'.tr
                      : 'level.part.passThisPart'.tr,
                  style: TextStyle(
                    color: yellow,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
          SizedBox(height: size.height * 0.02),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Show "Complete" only if full score (same as your old UI)
              if (passed || alreadyPassed)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: greenShadow,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.04,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          'level1.complete'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size.width * 0.038,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Repeat button (always visible)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFE5E5E5),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onRepeat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.replay),
                      SizedBox(width: size.width * .025),
                      Text(
                        'level1.repeat'.tr,
                        style: TextStyle(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1CB0F6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
