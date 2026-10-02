import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tracing_game/tracing_game.dart';

import '../controller/level_controller.dart';
class TracingView extends StatelessWidget {
  TracingView({super.key,
    required this.gglyph,
    required this.onTracingUpdated,
    required this.onFinished,
    required this.secondsLeft,
    required this.startCountdownIfNeeded,
  }) : glyph = gglyph;

  final String glyph;
  final Function(num progress) onTracingUpdated;
  Future<void> Function(int i) onFinished;
  final RxInt secondsLeft;
  final VoidCallback startCountdownIfNeeded;
  final String gglyph; // to keep constructor param distinct
  final LevelController c = Get.put(LevelController());
  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
              () => Text(
            'الوقت المتبقي: ${secondsLeft.value}s',
            style: TextStyle(
              fontSize: sz.width * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height:  sz.height*0.03),
        SizedBox(
          height: sz.height * 0.3,
          child: TracingCharsGame(
            showAnchor: true,
            traceShapeModel: [
              // one-screen with the current glyph
               c.tracingService.charsOneScreen([glyph]),
            ],
            //onTracingUpdated: onTracingUpdated,
            onCurrentTracingScreenFinished: (screenIndex) async {},
            onGameFinished: onFinished,
          ),
        ),
      ],
    );
  }
}

