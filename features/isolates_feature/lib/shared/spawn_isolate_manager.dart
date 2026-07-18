import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:isolates_feature/shared/isolate_manager.dart';

class SpawnIsolateManager implements IsolateManager {
  @override
  Future<R> executeWithCompute<T, R>(
      R Function(T) function, T parameter) async {
    return await compute(function, parameter);
  }

  @override
  Future<R> executeWithSpawn<T, R>(R Function(T) function, T parameter) async {
    if (kIsWeb) {
      throw UnsupportedError(
          'Isolate.spawn() is not supported on web platform. Use compute() instead.');
    }

    final receivePort = ReceivePort();
    final completer = Completer<R>();

    try {
      await Isolate.spawn(
        _isolateEntryPoint<T, R>,
        _IsolateData<T, R>(
          sendPort: receivePort.sendPort,
          function: function,
          parameter: parameter,
        ),
      );

      receivePort.listen((message) {
        receivePort.close();
        if (message is _IsolateError) {
          completer.completeError(message.error, message.stackTrace);
        } else {
          completer.complete(message as R);
        }
      });

      return await completer.future;
    } catch (e, stackTrace) {
      receivePort.close();
      completer.completeError(e, stackTrace);
      return await completer.future;
    }
  }

  @override
  bool get supportsSpawn => !kIsWeb;

  @override
  String get platformName => kIsWeb ? 'Web' : 'Mobile/Desktop';

  @override
  String get supportDescription => kIsWeb
      ? 'Web platform does not support Isolate.spawn() due to security restrictions'
      : 'Platform supports both compute() and Isolate.spawn()';

  static void _isolateEntryPoint<T, R>(_IsolateData<T, R> data) {
    try {
      final result = data.function(data.parameter);
      data.sendPort.send(result);
    } catch (error, stackTrace) {
      data.sendPort.send(_IsolateError(error, stackTrace));
    }
  }
}

class _IsolateData<T, R> {
  final SendPort sendPort;
  final R Function(T) function;
  final T parameter;

  _IsolateData({
    required this.sendPort,
    required this.function,
    required this.parameter,
  });
}

class _IsolateError {
  final Object error;
  final StackTrace stackTrace;

  _IsolateError(this.error, this.stackTrace);
}
