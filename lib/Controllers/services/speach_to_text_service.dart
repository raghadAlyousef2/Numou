import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vosk_flutter_2/vosk_flutter_2.dart';

//usage exampel
// final stt = Speech_to_text(
//   modelAssetZip: 'assets/models/vosk_ar.zip',
//   defaultTimeout: const Duration(seconds: 10),
// );
//
// await stt.init();
//
// final ok = await stt.listenKeyword('ألف'); // true if heard in <= 10s
// print(ok ? 'Heard it!' : 'Timeout, not heard.');
//

class SpeechToText extends GetxService {
  final String modelAssetZip='assets/models/vosk-model-ar-mgb2-0.4.zip';
  final int sampleRate=16000;
  final Duration defaultTimeout=const Duration(seconds: 10);

  final _vosk = VoskFlutterPlugin.instance();

  Model? _model;
  bool _initialized = false;
  /// Call once at app start.
  Future<void> _init() async {
    if (_initialized) return;
    final modelPath = await ModelLoader().loadFromAssets(modelAssetZip);
    //print(modelPath);
    _model = await _vosk.createModel(modelPath);
    _initialized = true;
  }

  /// Listens for a single [keyword] for up to [timeout].
  /// Returns true if heard, false otherwise.
  Future<bool> listenKeyword(
      String keyword, {
        Duration? timeout,
      }) async
  {
    if (!_initialized) {
      throw StateError('Call init() before listenKeyword()');
    }
    if (keyword.isEmpty) {
      throw ArgumentError('keyword cannot be empty');
    }

    final t = timeout ?? defaultTimeout;
    final completer = Completer<bool>();
    final recognized = <String>[];

    // Create recognizer WITHOUT grammar (some models don't support it)
    final recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: sampleRate,
      grammar: ['الف']
    );

    final speechService = await _vosk.initSpeechService(recognizer);

    bool found = false;

    String _extract(dynamic evt) {
      try {
        final m = evt as dynamic;
        if (m?.text != null) return m.text.toString();
        if (m?.partial != null) return m.partial.toString();
      } catch (_) {}
      return evt?.toString() ?? '';
    }

    bool _hit(String text, String key) {
      // simple contains; adapt if you need normalization
      return text.contains(key);
    }

    final timer = Timer(t, () {
      if (!completer.isCompleted) {
        debugPrint('Timeout, not heard.');
        completer.complete(false);
      }
    });

    final subPartial = speechService.onPartial().listen((evt) {
      final text = _extract(evt);
      if (text.isEmpty) return;
      recognized.add(text);
      debugPrint('partial: $text');
      if (!found && _hit(text, keyword)) {
        found = true;
        if (!completer.isCompleted) completer.complete(true);
      }
    });

    final subFinal = speechService.onResult().listen((evt) {
      final text = _extract(evt);
      if (text.isEmpty) return;
      recognized.add(text);
      debugPrint('final: $text');
      if (!found && _hit(text, keyword)) {
        found = true;
        if (!completer.isCompleted) completer.complete(true);
      }
    });




    await speechService.start();

    final result = await completer.future;

    // Cleanup
    timer.cancel();
    await speechService.stop();
    await subPartial.cancel();
    await subFinal.cancel();
    await speechService.dispose();
    await recognizer.dispose();

    // Print everything we heard in this session
    debugPrint('All recognized chunks: $recognized');

    return result;
  }


  /// Optional: free memory if you won’t use it again.
  Future<void> dispose() async {
    _model?.dispose();
    _model = null;
    _initialized = false;
  }

  // --------------------------------------------------

  String _extractText(dynamic evt) {
    try {
      // Handles objects that have .text or .partial
      final map = evt as dynamic;
      if (map?.text != null) return map.text.toString();
      if (map?.partial != null) return map.partial.toString();
    } catch (_) {
      // fallthrough
    }
    return evt?.toString() ?? '';
  }
  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
