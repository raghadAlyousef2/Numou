import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/level_controller.dart';


class MatchingQuizView extends StatelessWidget {
  MatchingQuizView({super.key});

  final _stackKey = GlobalKey();
  final _promptKey = GlobalKey(); // was _imageKey
  final List<GlobalKey> _optKeys = List.generate(4, (_) => GlobalKey());

  LevelController get c => Get.find<LevelController>();

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _captureCenters());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        key: _stackKey,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // LEFT: draggable WORD (Arabic text)
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onPanStart: (_) => c.quizBeginDrag(),
                      onPanUpdate: (d) =>
                          c.quizUpdateDrag(_toStackLocal(d.globalPosition)),
                      onPanEnd: (_) => c.quizEndDrag(),
                      onPanCancel: () => c.quizClearDrag(),
                      child: _PromptWordCard(
                          key: _promptKey, textRx: c.quizPromptAr),
                    ),
                  ),
                ),
                 SizedBox(width: size.width*0.20),

                // RIGHT: 4 IMAGE options (tap OR drag-to-snap)
                Expanded(
                  child: Obx(() {
                   // final assets = c.quizOptionAssets;
                    final assets = c.quizOptionAssets;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(assets.length, (i) {
                        return InkWell(
                          onTap: () =>
                              c.completeQuiz(
                                  isCorrect: i == c.quizAnswerIndex.value),
                          child: _ImageOptionCard(
                            key: _optKeys[i],
                            assetOrEmoji: assets[i],
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Lines layer (same as before)
          Positioned.fill(
            child: Obx(() =>
                IgnorePointer(
                  ignoring: true,
                  child: CustomPaint(
                    painter: _QuizLinePainter(
                      start: c.quizDragStart.value,
                      now: c.quizDragNow.value,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }


  // ------- geometry (unchanged, just use _promptKey) -------
  void _captureCenters() {
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    final promptC = _centerLocalOf(_promptKey, stackBox);
    if (promptC != null) c.quizRegisterImageCenter(promptC); // same API; center of the draggable thing

    for (var i = 0; i < _optKeys.length; i++) {
      final oc = _centerLocalOf(_optKeys[i], stackBox);
      if (oc != null) c.quizRegisterOptionCenter(i, oc);
    }
  }

  Offset? _centerLocalOf(GlobalKey key, RenderBox stackBox) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox;
    final size = box.size;
    final topLeftGlobal = box.localToGlobal(Offset.zero);
    final centerGlobal = topLeftGlobal + Offset(size.width / 2, size.height / 2);
    return stackBox.globalToLocal(centerGlobal);
  }

  Offset _toStackLocal(Offset global) {
    final stackBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
    return stackBox.globalToLocal(global);
  }

}




class _PromptWordCard extends StatelessWidget {
  final RxString textRx;
  const _PromptWordCard({super.key, required this.textRx});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Obx(() => Container(
      width: size.width*0.25, height: size.height*0.10,
      decoration: BoxDecoration(

        color: const Color(0xffe8ffe8),
        borderRadius: BorderRadius.circular(size.width*0.05),
        boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: -2)],
        border: Border.all(color: Colors.green.shade300, width: 2),
      ),

      alignment: Alignment.center,
      child: Text(
        textRx.value,
        textAlign: TextAlign.center,
        style:  TextStyle(fontSize: size.width*0.08, fontWeight: FontWeight.w800),
      ),
    ));
  }
}

class _ImageOptionCard extends StatelessWidget {
  final String assetOrEmoji;
  const _ImageOptionCard({super.key, required this.assetOrEmoji});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    Widget child;
    if (assetOrEmoji.startsWith('assets/')) {
      child = Image.asset(assetOrEmoji, fit: BoxFit.contain, width: size.width*0.35, height: size.height*0.8);
    } else {
      // fallback to an emoji char
      child = Text(assetOrEmoji, style:  TextStyle(fontSize: size.width*0.1));
    }

    return Container(
      height: size.height*0.08,
      width:  size.width*0.5,
      margin:  EdgeInsets.symmetric(vertical: size.height*0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width*0.05),
        boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: -2)],

      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}



// ------------------- painter -------------------

class _QuizLinePainter extends CustomPainter {
  final Offset? start;
  final Offset? now;

  _QuizLinePainter({required this.start, required this.now});

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || now == null) return;
    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(start!.dx, start!.dy);
    final dx = (now!.dx - start!.dx).abs() * 0.4;
    final c1 = Offset(start!.dx + dx, start!.dy);
    final c2 = Offset(now!.dx - dx, now!.dy);
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, now!.dx, now!.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _QuizLinePainter old) =>
      old.start != start || old.now != now;
}
