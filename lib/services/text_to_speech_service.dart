import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../Models/characters.dart';

// usage example
/*final speech = SpeechService();

await speech.init(
languageCode: "ar",   // Arabic
rate: 0.5,
pitch: 1.0,
volume: 1.0,
);

await speech.speak("مرحباً! أنا شخصية تفاعلية.");
await speech.stop();   // Stops immediately
await speech.pause();  // Pauses (Android SDK >= 26, iOS supported)*/

enum TtsState { playing, stopped, paused, continued }

class TextToSpeechService extends GetxService{

  final FlutterTts _tts = FlutterTts();
  TtsState _ttsState = TtsState.stopped;

  String? currentWord;
  bool isInitialized = false;

  // Future<void> _init({
  //   String languageCode = "ar",   // Default Arabic
  //   double volume = 1.0,
  //   double pitch = 1.0,
  //   double rate = 0.5,
  //   bool awaitCompletion = true,
  // }) async
  // {
  //   if (isInitialized) return;
  //   final langsRaw = await _tts.getLanguages;
  //   final langs = langsRaw.map((e) => e.toString()).toList();
  //   print("TTS languages on this device: $langs");
  //
  //   // Set language
  //   bool isAvailable = await _tts.isLanguageAvailable(languageCode);
  //   if (!isAvailable) {
  //     throw Exception("Language $languageCode is not available on this device.");
  //   }
  //
  //   await _tts.setLanguage(languageCode);
  //   await _tts.setVolume(volume);
  //   await _tts.setPitch(pitch);
  //   await _tts.setSpeechRate(rate);
  //
  //   if (Platform.isIOS) {
  //     await _tts.setSharedInstance(true);
  //   }
  //
  //   await _tts.awaitSpeakCompletion(awaitCompletion);
  //
  //   _setHandlers();
  //   isInitialized = true;
  // }

  // Future<void> _init({
  //   String languageCode = "ar",   // desired base language
  //   double volume = 1.0,
  //   double pitch = 1.0,
  //   double rate = 0.5,
  //   bool awaitCompletion = true,
  // }) async
  // {
  //   if (isInitialized) return;
  //
  //   // Ask device what languages are available
  //   final langsRaw = await _tts.getLanguages;
  //   final langs = langsRaw.map((e) => e.toString()).toList();
  //   print("TTS languages on this device: $langs");
  //
  //   String? chosenLocale;
  //
  //   // 1) Try Arabic variants (ar, ar-SA, etc.), though we know this device has none
  //   chosenLocale = langs.firstWhere(
  //         (l) => l.startsWith("ar"),
  //     orElse: () => "",
  //   );
  //
  //   // 2) If no Arabic, try English variants
  //   if (chosenLocale!.isEmpty) {
  //     chosenLocale = langs.firstWhere(
  //           (l) => l.startsWith("eng"),
  //       orElse: () => "",
  //     );
  //   }
  //
  //   // 3) If still nothing, just pick the first available as a last resort
  //   if (chosenLocale!.isEmpty && langs.isNotEmpty) {
  //     chosenLocale = langs.first;
  //   }
  //
  //   if (chosenLocale!.isEmpty) {
  //     // Device has no TTS at all
  //     print("TTS: No TTS languages available on this device.");
  //     isInitialized = false;
  //     return;
  //   }
  //
  //   print("TTS: Using locale $chosenLocale");
  //   await _tts.setLanguage(chosenLocale);
  //   await _tts.setVolume(volume);
  //   await _tts.setPitch(pitch);
  //   await _tts.setSpeechRate(rate);
  //
  //   if (Platform.isIOS) {
  //     await _tts.setSharedInstance(true);
  //   }
  //
  //   await _tts.awaitSpeakCompletion(awaitCompletion);
  //
  //   _setHandlers();
  //   isInitialized = true;
  // }
  Future<void> _init({
    String languageCode = "ar",   // desired base language
    double volume = 1.0,
    double pitch = 1.0,
    double rate = 0.5,
    bool awaitCompletion = true,
  }) async {
    if (isInitialized) return;

    // Ask device what languages are available
    final langsRaw = await _tts.getLanguages;
    final List<String> langs = langsRaw
        .map<String>((e) => e.toString())
        .toList();
    print("TTS languages on this device: $langs");

    // ---- pick locale safely ----
    String chosenLocale = "";

    // 1) Try Arabic variants (won't find any on this device but safe)
    chosenLocale = langs.firstWhere(
          (String l) => l.startsWith("ar"),
      orElse: () => "",
    );

    // 2) If no Arabic, try English variants
    if (chosenLocale.isEmpty) {
      chosenLocale = langs.firstWhere(
            (String l) => l.startsWith("eng"),
        orElse: () => "",
      );
    }

    // 3) If still nothing, just pick the first available as a last resort
    if (chosenLocale.isEmpty && langs.isNotEmpty) {
      chosenLocale = langs.first;
    }

    if (chosenLocale.isEmpty) {
      // Device has no TTS at all
      print("TTS: No TTS languages available on this device.");
      isInitialized = false;
      return;
    }

    print("TTS: Using locale $chosenLocale");
    await _tts.setLanguage(chosenLocale);
    await _tts.setVolume(volume);
    await _tts.setPitch(pitch);
    await _tts.setSpeechRate(rate);

    if (Platform.isIOS) {
      await _tts.setSharedInstance(true);
    }

    await _tts.awaitSpeakCompletion(awaitCompletion);

    _setHandlers();
    isInitialized = true;
  }

  void _setHandlers() {
    _tts.setStartHandler(() {
      _ttsState = TtsState.playing;
      print("TTS: Started");
    });

    _tts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
      print("TTS: Completed");
    });

    _tts.setPauseHandler(() {
      _ttsState = TtsState.paused;
      print("TTS: Paused");
    });

    _tts.setContinueHandler(() {
      _ttsState = TtsState.continued;
      print("TTS: Continued");
    });

    _tts.setCancelHandler(() {
      _ttsState = TtsState.stopped;
      print("TTS: Cancelled");
    });


    _tts.setProgressHandler((String text, int start, int end, String word) {
      currentWord = word;
      print("TTS: Speaking word - $word");
    });

    _tts.setErrorHandler((msg) {
      _ttsState = TtsState.stopped;
      print("TTS: Error - $msg");
    });
  }

  Future<void> speak(String text) async {
   // if (text.isEmpty) return;
    if (text.isEmpty || !isInitialized) return;
    var result = await _tts.speak(text);
    if (result != 1) {
      print("TTS: Speak failed");
    }
  }

  Future<void> stop() async {
    var result = await _tts.stop();
    if (result != 1) {
      print("TTS: Stop failed");
    }
  }

  Future<void> pause() async {
    try {
      var result = await _tts.pause();
      if (result != 1) {
        print("TTS: Pause failed");
      }
    } catch (e) {
      print("TTS: Pause not supported on this platform - $e");
    }
  }

  Future<void> setVoice(String name, String locale) async {
    await _tts.setVoice({"name": name, "locale": locale});
  }

  Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages;
  }

  Future<List<dynamic>> getVoices() async {
    return await _tts.getVoices;
  }

  TtsState get currentState => _ttsState;

  @override
  void onInit() {
//    _init();
    super.onInit();

    _init().catchError((e, st) {
      print("TTS init failed: $e");
      isInitialized = false;
    });


  }
  Future<void> printVoices() async {
    final voices = await _tts.getVoices;
    for (final v in voices) {
      final m = Map<String, dynamic>.from(v);
      print('name=${m['name']}  locale=${m['locale']}  quality=${m['quality'] ?? ''}');
    }
  }
  // Future<void> setLanguage(String locale) async {
  //   await _tts.setLanguage(locale);
  // }
  Future<void> setLanguage(String locale) async {
    try {
      // Ask device what languages are supported
      final langsRaw = await _tts.getLanguages;
      final List<String> langs = langsRaw
          .map<String>((e) => e.toString())
          .toList();

      // Check if the requested locale is really available
      final bool supported = langs.contains(locale);

      if (!supported) {
        print("TTS: Requested locale '$locale' is not available on this device. Keeping current language.");
        return; // don't change anything, keep the default from _init()
      }

      await _tts.setLanguage(locale);
      print("TTS: Language changed to $locale");
    } catch (e) {
      print("TTS: Failed to set language '$locale' → $e");
    }
  }
  //
  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  /// Safely apply a voice preset (falls back if name isn't available)
  Future<void> applyCharacterPreset(CharacterPreset p) async {
    await setLanguage(p.locale);
    final voices = await getVoices();
    final hasVoice = voices.any((v) {
      try {
        final m = Map<String, dynamic>.from(v);
        return (m['name'] == p.voiceName && (m['locale'] == p.locale));
      } catch (_) { return false; }
    });

    if (hasVoice) {
      await setVoice(p.voiceName, p.locale);
    } else {
      // fallback: just keep locale
    }
    await setRate(p.rate);
    await setPitch(p.pitch);
    await setVolume(p.volume);
  }

}
