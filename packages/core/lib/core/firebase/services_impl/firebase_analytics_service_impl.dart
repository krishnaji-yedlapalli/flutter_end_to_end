import 'package:app_core/core/firebase/services/firebase_analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Concrete implementation of [FirebaseAnalyticsService].
class FirebaseAnalyticsServiceImpl extends FirebaseAnalyticsService {
  FirebaseAnalyticsServiceImpl();

  late final FirebaseAnalytics _analytics;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
    // Disable analytics data collection in debug and profile builds.
    // Data is only collected in release mode.
    await _analytics.setAnalyticsCollectionEnabled(kReleaseMode);
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_isInitialized) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setCurrentScreen(String screenName,
      {String? screenClass}) async {
    if (!_isInitialized) return;
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserProperty(
      {required String name, required String? value}) async {
    if (!_isInitialized) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) return;
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> logLogin({String? loginMethod}) async {
    if (!_isInitialized) return;
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    if (!_isInitialized) return;
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }
}
