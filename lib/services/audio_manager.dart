import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioManagerController extends GetxService {
  late AudioPlayer bgPlayer;
  final AudioPlayer sfxPlayer = AudioPlayer();

  RxBool isMusicPlaying = true.obs;

  @override
  void onInit() {
    super.onInit();
    bgPlayer = AudioPlayer();
    bgPlayer.setReleaseMode(ReleaseMode.loop);

    Future.microtask(() async {
      await playBackgroundMusic();
    });
  }

  Future<void> playBackgroundMusic() async {
    await bgPlayer.play(AssetSource('sounds/skura_girl_background.mp3'), volume: 0.05);
    isMusicPlaying.value = true;
  }

  Future<void> stopBackgroundMusic() async {
    await bgPlayer.stop();
    isMusicPlaying.value = false;
  }

  Future<void> toggleMusic() async {
    if (isMusicPlaying.value) {
      await stopBackgroundMusic();
    } else {
      await playBackgroundMusic();
    }
  }

  Future<void> playButtonClick() async {
    await sfxPlayer.play(AssetSource('sounds/button_click.mp3'), volume: 1.0);
  }

  @override
  void onClose() {
    bgPlayer.dispose();
    sfxPlayer.dispose();
    super.onClose();
  }
}
