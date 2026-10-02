import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/services/audio_manager.dart';
import 'package:numou/services/letter_tracing_service.dart';
import 'package:numou/services/lottie_cashe_service.dart';
import 'package:numou/services/new_google_stt_service.dart';
import 'package:numou/services/permission_service.dart';

import 'package:numou/services/text_to_speech_service.dart';
import 'package:numou/services/translation_service.dart';
import 'package:numou/utiles/Constant/strings.dart';
import 'package:numou/utiles/Themes/theme.dart';
import 'package:numou/utiles/translations/translations.dart';
import 'Models/characters.dart';
import 'features/authentication/controllers/auth_controller.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final pid = Firebase.app().options.projectId;
  final hasPermission = await PermissionService.checkPermissions();
  if (!hasPermission) {
    // If permission denied, close app
    exit(0);
  }

  Get.put(AuthController());
 Get.put(AudioManagerController());
 Get.put(TextToSpeechService());
 Get.put(TracingService());
 Get.put(NewGoogleSpeechV2Service(projectId: pid,serviceAccountAsset: 'assets/keys/numou-a982e-1fbcf675697b.json'));
  Get.put(TranslationService(), permanent: true);
  final lottieCache = Get.put(LottieCacheService(), permanent: true);
  await lottieCache.preloadAll(
      // kCharacterPresets.values
      //     .map((p) => p.lottieAsset)
      //     .toSet() // avoid duplicates
    [
      'assets/characters/tom.json',
      'assets/characters/camel.json',
      'assets/characters/bear.json'
    ]
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: homePageAppBareTitle,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeMode.system,

      translations: AppTranslations(),
      locale: const Locale('ar', 'SA'), // Default: Arabic
      fallbackLocale: const Locale('en', 'US'),
      home: Scaffold(body: Center(child: SizedBox( height: MediaQuery.of(context).size.height*0.2, child: const CircularProgressIndicator()),)),

    );
  }
}



