import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

/// Example 1: Using compute() - Simplest approach
/// Best for one-off heavy computations
class ComputeExample {
  // Fibonacci calculation (CPU intensive)
  static Future<int> calculateFibonacci(int n) async {
    return await compute(_fibonacci, n);
  }

  static int _fibonacci(int n) {
    if (n <= 1) return n;
    return _fibonacci(n - 1) + _fibonacci(n - 2);
  }

  // JSON parsing (common use case)
  static Future<List<Map<String, dynamic>>> parseJson(String jsonString) async {
    return await compute(_parseJsonInIsolate, jsonString);
  }

  static List<Map<String, dynamic>> _parseJsonInIsolate(String jsonString) {
    final decoded = jsonDecode(jsonString) as List;
    return decoded.cast<Map<String, dynamic>>();
  }
}

/// Example 2: Basic Isolate with SendPort/ReceivePort
/// One-way communication: send data, get result, done
class BasicIsolateExample {
  static Future<String> processData(String data) async {
    final receivePort = ReceivePort();

    // Spawn isolate
    await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    // Get SendPort from spawned isolate
    final sendPort = await receivePort.first as SendPort;

    // Create port for response
    final responsePort = ReceivePort();
    sendPort.send([data, responsePort.sendPort]);

    // Wait for result
    final result = await responsePort.first as String;
    responsePort.close();

    return result;
  }

  static void _isolateEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();

    // Send our SendPort back to main isolate
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final data = message[0] as String;
      final replyPort = message[1] as SendPort;

      // Heavy processing
      final processed = data.split('').reversed.join().toUpperCase();

      replyPort.send(processed);
    });
  }
}

/// Example 3: Long-running Isolate Worker
/// Bidirectional communication: keep isolate alive for multiple tasks
class IsolateWorker {
  Isolate? _isolate;
  SendPort? _sendPort;
  final _receivePort = ReceivePort();
  bool _isInitialized = false;

  Future<void> start() async {
    if (_isInitialized) return;

    _isolate = await Isolate.spawn(_workerEntry, _receivePort.sendPort);
    _sendPort = await _receivePort.first as SendPort;
    _isInitialized = true;
  }

  Future<int> sumNumbers(int n) async {
    if (!_isInitialized) throw StateError('Worker not started');

    final responsePort = ReceivePort();
    _sendPort!.send({'task': 'sum', 'n': n, 'port': responsePort.sendPort});

    final result = await responsePort.first as int;
    responsePort.close();
    return result;
  }

  Future<List<int>> generatePrimes(int limit) async {
    if (!_isInitialized) throw StateError('Worker not started');

    final responsePort = ReceivePort();
    _sendPort!.send(
        {'task': 'primes', 'limit': limit, 'port': responsePort.sendPort});

    final result = await responsePort.first as List<int>;
    responsePort.close();
    return result;
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort.close();
    _isInitialized = false;
  }

  static void _workerEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final task = message['task'] as String;
      final replyPort = message['port'] as SendPort;

      switch (task) {
        case 'sum':
          final n = message['n'] as int;
          int sum = 0;
          for (int i = 1; i <= n; i++) {
            sum += i;
          }
          replyPort.send(sum);
          break;

        case 'primes':
          final limit = message['limit'] as int;
          final primes = <int>[];
          for (int i = 2; i <= limit; i++) {
            bool isPrime = true;
            for (int j = 2; j * j <= i; j++) {
              if (i % j == 0) {
                isPrime = false;
                break;
              }
            }
            if (isPrime) primes.add(i);
          }
          replyPort.send(primes);
          break;
      }
    });
  }
}

/// Example 4: Isolate with dart:io (File processing)
class FileIsolateExample {
  static Future<Map<String, int>> countWords(String filePath) async {
    return await compute(_countWordsInFile, filePath);
  }

  static Map<String, int> _countWordsInFile(String filePath) {
    // Note: In real app, handle file reading properly
    // This is just to show dart:io works in isolates
    final words = <String, int>{};
    const content = 'sample text for word counting sample';

    for (final word in content.split(' ')) {
      words[word] = (words[word] ?? 0) + 1;
    }

    return words;
  }
}
