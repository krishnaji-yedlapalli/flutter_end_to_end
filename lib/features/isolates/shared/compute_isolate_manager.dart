import 'package:flutter/foundation.dart';
import 'package:sample_latest/features/isolates/shared/isolate_manager.dart';

class ComputeIsolateManager implements IsolateManager {
  @override
  Future<R> executeWithCompute<T, R>(
      R Function(T) function, T parameter) async {
    return await compute(function, parameter);
  }

  @override
  Future<R> executeWithSpawn<T, R>(R Function(T) function, T parameter) async {
    // Fallback to compute on platforms that don't support spawn
    return await compute(function, parameter);
  }

  @override
  bool get supportsSpawn => false;

  @override
  String get platformName => kIsWeb ? 'Web' : 'Mobile/Desktop';

  @override
  String get supportDescription => kIsWeb
      ? 'Web platform supports compute() but not Isolate.spawn()'
      : 'Platform supports compute() with web worker fallback';
}
