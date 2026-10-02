// services/lottie_cache_service.dart
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LottieCacheService extends GetxService {
  final _map = <String, LottieComposition>{};

  Future<void> preload(String assetPath) async {
    if (_map.containsKey(assetPath)) return;
    final ByteData bytes = await rootBundle.load(assetPath);
    final comp = await LottieComposition.fromByteData(bytes);
    _map[assetPath] = comp;
  }

  Future<void> preloadAll(Iterable<String> assets) =>
      Future.wait(assets.map(preload));

  LottieComposition? get(String assetPath) => _map[assetPath];

  // NEW: allow UI to store a composition after first load
  void put(String assetPath, LottieComposition comp) {
    _map[assetPath] = comp;
  }

  // (optional)
  bool has(String assetPath) => _map.containsKey(assetPath);
  void clear([String? assetPath]) =>
      assetPath == null ? _map.clear() : _map.remove(assetPath);
}
