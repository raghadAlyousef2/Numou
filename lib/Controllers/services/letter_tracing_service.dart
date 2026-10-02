import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracing_game/tracing_game.dart';

//final tracing = Get.put(TracingService());

// // 1) letters — one screen with multiple letters
// final charModels = [tracing.charsOneScreen(['أ','ل','ف'])];
// return TracingCharsGame(
// showAnchor: true,
// traceShapeModel: charModels,
// onTracingUpdated: (i) async { /* ... */ },
// onCurrentTracingScreenFinished: (i) async { /* ... */ },
// onGameFinished: (i) async { /* ... */ },
// );
//
// // 2) letters — multiple screens, one per letter
// final multi = tracing.charsMultiScreens([['ا'], ['ل'], ['ف']]);
// return TracingCharsGame(
// showAnchor: true,
// traceShapeModel: multi,
// onTracingUpdated: (i) async {},
// onCurrentTracingScreenFinished: (i) async {},
// onGameFinished: (i) async {},
// );
//
// // 3) words
// final wordModels = tracing.words(['أنا', 'أحب', 'التتبع']);
// return TracingWordGame(
// words: wordModels,
// onTracingUpdated: (i) async {},
// onCurrentTracingScreenFinished: (i) async {},
// onGameFinished: (i) async {},
// );
//
// // 4) shapes
// final shapeScreens = tracing.shapesScreens([
// [MathShapes.circle, MathShapes.triangle1],
// [MathShapes.rectangle, MathShapes.triangle2],
// ]);
// return TracingGeometricShapesGame(
// traceGeoMetricShapeModels: shapeScreens,
// );


/// Build-only service: returns models for `tracing_game`.
/// You place the widgets yourself and wire the callbacks in your UI.
class TracingService extends GetxService {
  /// App-wide default appearance (package supports only these 4 fields).
  final TraceShapeOptions defaultOptions = const TraceShapeOptions(
    dottedColor: Colors.grey,
    indexColor: Color.fromRGBO(255, 183, 37, 1),
    innerPaintColor: Colors.black,
    outerPaintColor: Colors.blue,
  );

  // ----------------- CHARS (letters) -----------------

  /// Single screen with a single character (e.g., 'أ').
  TraceCharsModel charScreen(
      String char, {
        TraceShapeOptions? options,
      }) {
    return TraceCharsModel(
      chars: [
        TraceCharModel(
          char: char,
          traceShapeOptions: options ?? defaultOptions,
        ),
      ],
    );
  }

  /// Single screen with multiple characters (e.g., ['أ','ل','ف']).
  TraceCharsModel charsOneScreen(
      List<String> chars, {
        TraceShapeOptions? options,
      }) {
    final opt = options ?? defaultOptions;
    return TraceCharsModel(
      chars: chars
          .map((c) => TraceCharModel(char: c, traceShapeOptions: opt))
          .toList(),
    );
  }

  /// Multiple screens; each inner list is one screen.
  /// Example: screens = [['ا'], ['ل'], ['ف']]
  List<TraceCharsModel> charsMultiScreens(
      List<List<String>> screens, {
        TraceShapeOptions? options,
      }) {
    final opt = options ?? defaultOptions;
    return screens
        .map((screenChars) => TraceCharsModel(
      chars: screenChars
          .map((c) => TraceCharModel(char: c, traceShapeOptions: opt))
          .toList(),
    ))
        .toList();
  }

  // --------------- WORDS (TracingWordGame) ---------------

  /// Build word models for TracingWordGame.
  /// Example: words(['أنا', 'أحب', 'التتبع'])
  List<TraceWordModel> words(
      List<String> words, {
        TraceShapeOptions? options,
      }) {
    final opt = options ?? defaultOptions;
    return words
        .map((w) => TraceWordModel(word: w, traceShapeOptions: opt))
        .toList();
  }

  // --------- GEOMETRIC SHAPES (TracingGeometricShapesGame) ---------

  /// Build multiple screens of shapes.
  /// Each inner list is a screen of shapes.
  /// Example:
  /// shapesScreens([
  ///   [MathShapes.circle, MathShapes.triangle1],
  ///   [MathShapes.rectangle, MathShapes.triangle2],
  /// ])
  List<TraceGeoMetricShapeModel> shapesScreens(
      List<List<MathShapes>> screens, {
        TraceShapeOptions? options,
      }) {
    final opt = options ?? defaultOptions;
    return screens
        .map((shapes) => TraceGeoMetricShapeModel(
      shapes: shapes
          .map((s) => MathShapeWithOption(
        shape: s,
        traceShapeOptions: opt,
      ))
          .toList(),
    ))
        .toList();
  }
}
