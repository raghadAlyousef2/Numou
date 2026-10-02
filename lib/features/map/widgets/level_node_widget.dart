import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Models/Child.dart';
import '../../../Models/letters_seed.dart';
class LevelNodeWidget extends StatelessWidget {
  final double size;          // base size for node
  final LetterSeed seed;      // has id + glyph
  final LetterStatus status;
  final VoidCallback? onTap;

  const LevelNodeWidget({super.key,
    required this.size,
    required this.seed,
    required this.status,
    this.onTap,
  });

  // ---------- deterministic “random” text color ----------
  static const _glyphPalette = <Color>[
    Color(0xFFEF5350), // red
    Color(0xFFAB47BC), // purple
    Color(0xFF5C6BC0), // indigo
    Color(0xFF29B6F6), // light blue
    Color(0xFF26A69A), // teal
    Color(0xFF66BB6A), // green
    Color(0xFFFFA726), // orange
    Color(0xFFFF7043), // deep orange
  ];



  Color _colorForId(String id) {
    final h = id.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) & 0x7fffffff);
    return _glyphPalette[h % _glyphPalette.length];
  }

  // ---------- soft outer glow ----------
  List<BoxShadow> _glow(Color c) => [
    // big haze
    BoxShadow(color: c.withOpacity(0.25), blurRadius: 30, spreadRadius: 4),
    // medium halo
    BoxShadow(color: c.withOpacity(0.35), blurRadius: 18, spreadRadius: 2),
    // tight rim light
    BoxShadow(color: c.withOpacity(0.5), blurRadius: 8, spreadRadius: 1),
    // drop shadow for depth
    const BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 7)),
  ];

  @override
  Widget build(BuildContext context) {
    // Ring + fill by status
    final ringColor = switch (status) {
      LetterStatus.locked   => const Color(0xFF90A4AE), // gray-blue
      LetterStatus.unlocked => const Color(0xFF3DDC84), // fresh green
      LetterStatus.passed   => const Color(0xFFFFC107), // gold
    };

    final baseGradient = switch (status) {
      LetterStatus.locked   => const [Color(0xFFE6E9EC), Color(0xFFCFD8DC)],
      LetterStatus.unlocked => const [Color(0xFFEAFEEC), Color(0xFFC8F7D3)],
      LetterStatus.passed   => const [Color(0xFFFFF3B0), Color(0xFFFFD54F)],
    };

    final IconData icon = switch (status) {
      LetterStatus.passed   => Icons.stars_rounded,
      LetterStatus.unlocked => CupertinoIcons.lock_open,
      LetterStatus.locked   => Icons.lock_rounded,
    };

    final iconColor = switch (status) {
      LetterStatus.passed   => const Color(0xFFFFB300),
      LetterStatus.unlocked => const Color(0xFF2E7D32),
      LetterStatus.locked   => const Color(0xFF70838B),
    };

    // Capsule size
    final capsuleW = size * 1.28;
    final capsuleH = size * 0.88;

    // Tilt: rotateZ + slight 3D rotateX + a tiny skewY for that diagonal vibe
    const tiltZDeg = 10.0;          // diagonal lean
    const tiltXDeg = -6.0;          // 3D perspective tilt
    const skewYDeg = -3.5;          // slight slant

    Widget capsuleCore = Container(
      width: capsuleW,
      height: capsuleH,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // gradient fill
        gradient: LinearGradient(
          colors: baseGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // stadium (capsule)
        borderRadius: BorderRadius.circular(capsuleH / 2),
        // gradient rim (simulate with two borders via Stack below)
        border: Border.all(color: ringColor, width: 2.5),
        // outer glow
        boxShadow: _glow(ringColor),
      ),
      // glossy sweep highlight
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(capsuleH / 2),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.26),
            Colors.white.withOpacity(0.04),
            Colors.white.withOpacity(0.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(icon, size: capsuleH * 0.56, color: iconColor),
    );

    // Add a subtle inner rim: stack a thinner inner container
    capsuleCore = Stack(
      alignment: Alignment.center,
      children: [
        capsuleCore,
        Container(
          width: capsuleW - 6,
          height: capsuleH - 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((capsuleH - 6) / 2),
            border: Border.all(
              width: 1.8,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ),
      ],
    );

    // Compose the tilt (rotateZ + rotateX) and tiny skew
    final tilted = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0014)                 // perspective
        ..rotateZ(tiltZDeg * math.pi / 180)
        ..rotateX(tiltXDeg * math.pi / 180),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.skewY(skewYDeg * math.pi / 180),
        child: capsuleCore,
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Letter glyph pill (deterministic colored text)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ringColor, width: 2),
              boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
            ),
            child: Text(
              seed.glyph, // "أ" etc.
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _colorForId(seed.id),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Tilted glowing capsule
          tilted,
        ],
      ),
    );
  }
}
