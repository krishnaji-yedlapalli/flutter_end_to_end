import 'package:sample_latest/core/firebase/services/firebase_service.dart';

/// Abstract contract for Firebase Crashlytics.
///
/// Provides a testable interface for crash reporting across the app.
abstract class FirebaseCrashlyticsService extends FirebaseService {
  /// Records a non-fatal error.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Logs a message to Crashlytics (visible in crash reports).
  Future<void> log(String message);

  /// Sets a custom key-value pair for crash context.
  Future<void> setCustomKey(String key, Object value);

  /// Sets the user identifier for crash reports.
  Future<void> setUserIdentifier(String userId);

  /// Enables or disables crash data collection.
  Future<void> setCrashlyticsCollectionEnabled(bool enabled);
}
