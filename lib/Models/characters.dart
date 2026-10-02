class CharacterPreset {
  final String key;            // e.g. 'tom'
  final String arName;         // Arabic display
  final String lottieAsset;    // assets/characters/tom.json
  final String voiceName;      // e.g. 'ar-xa-x-ard-network' (device dependent)
  final String locale;         // e.g. 'ar'
  final double rate;
  final double pitch;
  final double volume;
  const CharacterPreset({
    required this.key,
    required this.arName,
    required this.lottieAsset,
    required this.voiceName,
    required this.locale,
    this.rate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
  });
}

const Map<String, CharacterPreset> kCharacterPresets = {
  'tom': CharacterPreset(
    key: 'tom',
    arName: 'توم',
    lottieAsset: 'assets/characters/tom.json',
    voiceName: 'ar-xa-x-are-local',
    locale: 'ar',
    rate: 0.42,
    pitch: 1.9,
  ),
  'camel': CharacterPreset(
    key: 'camel',
    arName: 'الجمل',
    lottieAsset: 'assets/characters/camel.json',
    voiceName: 'ar-xa-x-arz-local',
    locale: 'ar',
    rate: 0.42,
    pitch: 1.7,
  ),
  // 'frog': CharacterPreset(
  //   key: 'frog',
  //   arName: 'الضفدع',
  //   lottieAsset: 'assets/characters/frog.json',
  //   voiceName: 'ar-xa-x-ema-network',
  //   locale: 'ar',
  //   rate: 0.50,
  //   pitch: 1.10,
  // ),
  'bear': CharacterPreset(
    key: 'bear',
    arName: 'الدب',
    lottieAsset: 'assets/characters/bear.json',
    voiceName: 'ar-xa-x-ard-local',
    locale: 'ar',
    rate: 0.46,
    pitch: 2.0,
  ),
  // 'cat': CharacterPreset(
  //   key: 'cat',
  //   arName: 'القطة',
  //   lottieAsset: 'assets/characters/cat.json',
  //   voiceName: 'ar-xa-x-ard-network',
  //   locale: 'ar',
  //   rate: 0.5,
  //   pitch: 1.05,
  // ),
};
