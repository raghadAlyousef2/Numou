import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService extends GetxService {
  late final OnDeviceTranslator _translator;
  final OnDeviceTranslatorModelManager _modelManager =
  OnDeviceTranslatorModelManager();

  bool _isReady = false;

  /// Call once (e.g. in main) or lazy: first time translate pe ye khud call ho jayega.
  Future<TranslationService> init() async
  {
    if (_isReady) return this;

    // Make sure EN & AR models are downloaded on device
    await _downloadModelIfNeeded(TranslateLanguage.english);
    await _downloadModelIfNeeded(TranslateLanguage.arabic);

    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.arabic,
    );

    _isReady = true;
    return this;
  }

  Future<void> _downloadModelIfNeeded(TranslateLanguage lang) async
  {
    final code = lang.bcpCode;
    final isDownloaded = await _modelManager.isModelDownloaded(code);
    if (!isDownloaded) {
      await _modelManager.downloadModel(code);
    }
  }

  /// Main function: English string → Arabic string
  Future<String> translateToArabic(String text) async
  {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;

    if (!_isReady) {
      await init();
    }

    try {
      final result = await _translator.translateText(trimmed);
      return result;
    } catch (e) {
      print('MLKit translate error: $e');
      // fallback: agar kuch issue ho jaye to English hi dikhao
      return text;
    }
  }

  @override
  void onClose() {
    // resources free karne ke liye
    _translator.close();
    super.onClose();
  }
}
