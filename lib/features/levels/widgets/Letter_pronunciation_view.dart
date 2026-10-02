import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LetterPronunciationView extends StatefulWidget {
  const LetterPronunciationView({
    super.key,
    required this.glyph,
    required this.onRetry,
  });

  final String glyph;
  final VoidCallback onRetry;

  @override
  State<LetterPronunciationView> createState() =>
      _LetterPronunciationViewState();
}

class _LetterPronunciationViewState extends State<LetterPronunciationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late double _baseHue; // 0..360
  final green = const Color(0xFF58CC02);
  final greenShadow = const Color(0xFF58A700);

  @override
  void initState() {
    super.initState();
    _baseHue = Random().nextDouble() * 360.0;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // smooth looping rainbow
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final glyph = widget.glyph.isEmpty ? 'أ' : widget.glyph;

    Widget animatedRainbowText = AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        // rotate hue over time
        final startHue = (_baseHue + _ctrl.value * 360.0) % 360.0;

        // build a sweep gradient with 6 colors (every 60°)
        final colors = List<Color>.generate(6, (i) {
          final h = (startHue + i * 60.0) % 360.0;
          return HSVColor.fromAHSV(1.0, h, 0.90, 0.98).toColor();
        });

        // use ShaderMask so the gradient fills only the text glyph
        return ShaderMask(
          shaderCallback: (bounds) => SweepGradient(
            colors: colors + [colors.first], // close the loop
            startAngle: 0.0,
            endAngle: 6.283185307, // 2π
            center: Alignment.center,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            glyph,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.height * 0.10,
              fontWeight: FontWeight.bold,
              height: size.height*0.002,
              // color doesn't matter because ShaderMask uses srcIn,
              // but keep it non-null to avoid defaults changing metrics.
              color: Colors.white,
            ),
          ),
        );
      },
    );

    // tap the letter to reroll a new palette
    animatedRainbowText = GestureDetector(
      onTap: () => setState(() => _baseHue = Random().nextDouble() * 360.0),
      child: animatedRainbowText,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animatedRainbowText,
        SizedBox(height: size.height*0.01),
        Image.asset(
          'assets/images/level_one_character_1.png',
          height: size.height * 0.16,
          width: size.width * 0.6,
          fit: BoxFit.contain,
        ),
         SizedBox(height: size.height*0.01),
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
            onPressed: widget.onRetry,
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
