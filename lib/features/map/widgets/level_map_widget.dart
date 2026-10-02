import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../Models/Child.dart';
import '../../../Models/letters_seed.dart';
import '../../../utiles/Widgets/arabic_progress_bar.dart';
import 'level_node_widget.dart';

typedef LetterStatusResolver = LetterStatus Function(String letterId);
typedef PointsResolver       = int Function(String letterId);

class LevelMapWidget extends StatefulWidget {
  final List<LetterSeed> letters;
  final LetterStatusResolver statusOf; // e.g. controller.statusOf
  final PointsResolver pointsOf;       // optional, can be (_) => 0
  final void Function(String letterId)? onTapLetter;

  /// Visual tuning
  final double nodeSize;   // circle size in px
  final double spacingY;   // vertical step between nodes
  final EdgeInsets padding;

  const LevelMapWidget({
    super.key,
    required this.letters,
    required this.statusOf,
    required this.pointsOf,
    this.onTapLetter,
    this.nodeSize = 64,
    this.spacingY = 160,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
  });

  @override
  State<LevelMapWidget> createState() => _LevelMapWidgetState();
}

class _LevelMapWidgetState extends State<LevelMapWidget> {
  late final TransformationController _tc;
  final _ivKey = GlobalKey();

  // Remember which index we last centered on
  int _lastCenteredIndex = -1;

  // Keep min/maxScale in one place (must match InteractiveViewer below)
  static const double _minScale = 0.75;
  static const double _maxScale = 2.2;

  @override
  void initState() {
    super.initState();
    _tc = TransformationController();
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodes = widget.letters;


    if (nodes.isEmpty) {
      return const Center(child: Text('لا توجد مستويات'));
    }

    // Canvas size: tall enough for all nodes
    final viewportW = MediaQuery.of(context).size.width; // viewport width
    final childW    = viewportW; // child width equals viewport width
    final childH    = widget.padding.vertical + (nodes.length - 1) * widget.spacingY + 2 * widget.nodeSize;

    // Pre-compute node positions (bottom -> top), snaking left-right
    final List<Offset> positions = _buildSnakePositions(
      count: nodes.length,
      width: childW - widget.padding.horizontal,
      topOffset: widget.padding.top,
      nodeSize: widget.nodeSize,
      spacingY: widget.spacingY,
    );

    // Center on unlocked after first layout (and whenever target index changes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnUnlocked(positions, Size(childW, childH));
    });

    return InteractiveViewer(
      key: _ivKey,
      transformationController: _tc,
      minScale: _minScale,
      maxScale: _maxScale,
      constrained: false,
      clipBehavior: Clip.hardEdge, // avoid showing gutters outside the viewport
      child: SizedBox(
        width: childW,
        height: childH,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/map_bg6.JPG', // make this a tileable strip
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                repeat: ImageRepeat.repeatY,     // repeat only vertically
              ),
            ),

            // Nodes
            ...List.generate(nodes.length, (i) {
              final seed   = nodes[i];
              final status = widget.statusOf(seed.id);
              final pos    = positions[i] + Offset(widget.padding.left, 0);

              return Positioned(
                left: pos.dx - widget.nodeSize / 2,
                top:  pos.dy - widget.nodeSize / 2,
                child: LevelNodeWidget(
                  size: widget.nodeSize,
                  seed: seed,
                  status: status,
                  onTap: () => widget.onTapLetter?.call(seed.id),
                ),
              );
            }),


          ],
        ),
      ),
    );
  }

  /// Center the view on the current unlocked node (or fallback) without showing white gutters.
  void _centerOnUnlocked(List<Offset> positions, Size childSize) {
    if (!mounted) return;

    final int? idx = _findTargetIndex();
    if (idx == null) return;
    if (idx == _lastCenteredIndex) return; // nothing to do

    final Size? vp = _ivKey.currentContext?.size; // viewport (InteractiveViewer) size
    if (vp == null) return;

    final double cw = childSize.width;   // child width
    final double ch = childSize.height;  // child height
    final double vw = vp.width;          // viewport width
    final double vh = vp.height;         // viewport height

    // Scale that guarantees no whitespace in BOTH axes: cw*s >= vw and ch*s >= vh
    final double sFit = math.max(vw / cw, vh / ch);
    final double s = sFit.clamp(_minScale, _maxScale).toDouble();

    // World position of the target node (child coordinates)
    final Offset target = positions[idx] + Offset(widget.padding.left, 0);

    // Ideal pan to center target at viewport center
    final double txIdeal = vw / 2 - target.dx * s;
    final double tyIdeal = vh / 2 - target.dy * s;

    // Clamp pan so scaled child fully covers viewport (no gutters)
    final double txMin = vw - cw * s;   // far left allowed
    final double txMax = 0.0;           // far right allowed
    final double tyMin = vh - ch * s;   // top allowed
    final double tyMax = 0.0;           // bottom allowed

    final double tx = txIdeal.clamp(txMin, txMax).toDouble();
    final double ty = tyIdeal.clamp(tyMin, tyMax).toDouble();

    // IMPORTANT: translate THEN scale => result is (S * v) then + T (no scaled T)
    _tc.value = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(s);

    _lastCenteredIndex = idx;
  }

  /// Find the index to center on: first unlocked → last passed → first node.
  int? _findTargetIndex() {
    if (widget.letters.isEmpty) return null;

    // 1) first unlocked
    for (int i = 0; i < widget.letters.length; i++) {
      if (widget.statusOf(widget.letters[i].id) == LetterStatus.unlocked) return i;
    }
    // 2) else last passed
    for (int i = widget.letters.length - 1; i >= 0; i--) {
      if (widget.statusOf(widget.letters[i].id) == LetterStatus.passed) return i;
    }
    // 3) else first node
    return 0;
  }

  /// Make a simple snake path: bottom->top, alternating X.
  List<Offset> _buildSnakePositions({
    required int count,
    required double width,
    required double topOffset,
    required double nodeSize,
    required double spacingY,
  })
  {
    final cxLeft  = nodeSize * 1;
    final cxMid   = width / 2;
    final cxRight = width - nodeSize * 1;
    final xs = [cxLeft, cxMid, cxRight, cxMid]; // repeat pattern

    final List<Offset> out = [];
    // bottom first
    for (int i = 0; i < count; i++) {
      final y = (topOffset + (count - 1 - i) * spacingY) + nodeSize; // invert so bottom is index 0 visually
      final x = xs[i % xs.length];
      out.add(Offset(x, y));
    }
    return out;
  }
}

