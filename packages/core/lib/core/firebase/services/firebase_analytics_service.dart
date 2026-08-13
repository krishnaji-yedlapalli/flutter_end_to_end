import 'package:app_core/core/firebase/services/firebase_service.dart';

/// Abstract contract for Firebase Analytics.
///
/// Features should depend on this abstraction, not on the Firebase SDK directly.
abstract class FirebaseAnalyticsService extends FirebaseService {
  /// Log a custom event with optional parameters.
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  /// Set the current screen for screen-view tracking.
  Future<void> setCurrentScreen(String screenName, {String? screenClass});

  /// Set a user property.
  Future<void> setUserProperty({required String name, required String? value});

  /// Set the user ID for analytics.
  Future<void> setUserId(String? userId);

  /// Log a login event.
  Future<void> logLogin({String? loginMethod});

  /// Log a sign-up event.
  Future<void> logSignUp({required String signUpMethod});
}
