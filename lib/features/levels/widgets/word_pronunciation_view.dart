import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WordPronunciationView extends StatelessWidget {
  const WordPronunciationView({super.key,
    required this.glyph,
    required this.word,
    required this.onRetry,
    required this.imagePath,
    required this.textIcon,
  });

  final String glyph;
  final String word;
  final VoidCallback onRetry;
  final String imagePath;
  final String textIcon;
  final green = const Color(0xFF58CC02);
  final greenShadow = const Color(0xFF58A700);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(word,style: TextStyle(fontWeight: FontWeight.bold,fontSize: size.width*0.10,color: Colors.red),),

            // Image.asset(imagePath, height: size.height * 0.17,
            //   width: size.width * 0.9,
            //   fit: BoxFit.contain,),
    Text(textIcon,style: TextStyle(fontSize: size.width*0.23),),

         SizedBox(height: size.height*0.01),
        Image.asset(
          'assets/images/level_one_character_1.png',
          height: size.height * 0.12,
          width: size.width * 0.6,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: greenShadow,
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.replay, color: Colors.white),
            label: Text(
              'button.tryAgain'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.038,
                color: Colors.white,
              ),
            ),
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
          ),
        ),
      ],
    );
  }
}
