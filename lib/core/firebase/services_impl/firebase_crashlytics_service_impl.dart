import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sample_latest/core/firebase/services/firebase_crashlytics_service.dart';

/// Concrete implementation of [FirebaseCrashlyticsService].
class FirebaseCrashlyticsServiceImpl extends FirebaseCrashlyticsService {
  FirebaseCrashlyticsServiceImpl();

  late final FirebaseCrashlytics _crashlytics;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _crashlytics = FirebaseCrashlytics.instance;
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> log(String message) async {
    if (!_isInitialized) return;
    _crashlytics.log(message);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!_isInitialized) return;
    await _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserIdentifier(String userId) async {
    if (!_isInitialized) return;
    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    if (!_isInitialized) return;
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}
