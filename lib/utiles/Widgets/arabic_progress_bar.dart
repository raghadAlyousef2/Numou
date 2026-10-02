import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArabicProgressBar extends StatelessWidget {
  final double progressValue; // 0.0 to 1.0
  final String levelText;
  final int points;

  const ArabicProgressBar({
    super.key,
    required this.progressValue,
    this.levelText = "ready.level.beginner",
    this.points = 4*28,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
          return Container(
            padding:  EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width*0.03),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Row(

              children: [
                // Right side: Level Text
                Text(
                  levelText.tr,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: size.width*.02),

               SizedBox(
                 height: size.height*.03,
                 width: size.width*.4,
                 child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width*0.2),
                      child: LinearProgressIndicator(
                        value: progressValue, // Example: 0.3
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        semanticsLabel: 'Progress',
                        semanticsValue: '${(progressValue * 100).round()}%',
                      ),
                    ),
               ),

               SizedBox(width: size.width*.02),
                // Left side: Points and Icon
                Row(
                  children: [


                     SizedBox(width: size.width*.01),
                     Text(
                     'ready.points'.tr,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(width: size.width*.01),
                Icon(Icons.local_fire_department,
                        color: Colors.orange, size: size.width*0.05),
                    SizedBox(width: size.width*.01),
                    Text(
                      points.toString(),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

  }
}
