
import 'package:flutter/material.dart';

class GrayscaleWidget extends StatelessWidget {
  final Widget child;
  final bool isGrayscale;
  final bool isAbsorb;

  const GrayscaleWidget({super.key, required this.child, required this.isGrayscale ,required this.isAbsorb});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAbsorb, // Disables interactions when in grayscale mode
      child: ColorFiltered(
        colorFilter: isGrayscale
            ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
            : const ColorFilter.mode(Colors.transparent, BlendMode.saturation),
        child: child,
      ),
    );
  }
}
