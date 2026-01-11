import 'dart:async';

/// Abstract interface for isolate operations
abstract class IsolateManager {
  /// Execute a function in an isolate using compute()
  Future<R> executeWithCompute<T, R>(R Function(T) function, T parameter);

  /// Execute a function in a spawned isolate (if supported)
  Future<R> executeWithSpawn<T, R>(R Function(T) function, T parameter);

  /// Check if spawn isolates are supported on current platform
  bool get supportsSpawn;

  /// Get platform name for display
  String get platformName;

  /// Get platform support description
  String get supportDescription;
}
