import 'package:app_core/core/common/logger/debug_log.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Plays short SFX assets via the shared [SoLoud] engine.
class SoundEffectsPlayer {
  SoundEffectsPlayer._();

  static Future<void>? _initFuture;

  static Future<void> _ensureInitialized() {
    final soloud = SoLoud.instance;
    if (soloud.isInitialized) return Future.value();
    return _initFuture ??= () async {
      try {
        await soloud.init();
      } catch (_) {
        _initFuture = null;
        rethrow;
      }
    }();
  }

  static Future<void> play(String assetPath) async {
    try {
      await _ensureInitialized();
      await SoLoud.instance.playSource(asset: assetPath);
    } catch (e, st) {
      LogData.print('SoundEffectsPlayer failed to play $assetPath: $e\n$st');
    }
  }
}
