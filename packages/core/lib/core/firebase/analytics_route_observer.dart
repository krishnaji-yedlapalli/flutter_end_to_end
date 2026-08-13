import 'package:app_core/core/firebase/services/firebase_analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// A [NavigatorObserver] that logs screen views to Firebase Analytics
/// whenever GoRouter navigates to a new route.
///
/// Attach this to [GoRouter.observers] to get automatic screen tracking
/// on all platforms including web.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreen(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _trackScreen(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _trackScreen(previousRoute);
  }

  void _trackScreen(Route<dynamic> route) {
    // Extract a meaningful screen name from the route.
    // GoRouter sets route.settings.name to the full path (e.g. /home/schools).
    final screenName = route.settings.name;
    if (screenName == null || screenName.isEmpty) return;

    if (!GetIt.I.isRegistered<FirebaseAnalyticsService>()) return;

    GetIt.I<FirebaseAnalyticsService>().setCurrentScreen(
      screenName,
      screenClass: _screenClass(screenName),
    );

    if (kDebugMode) {
      debugPrint('[Analytics] Screen: $screenName');
    }
  }

  /// Derives a short class name from the path for grouping in the dashboard.
  /// e.g. "/home/schools/details" → "details"
  String _screenClass(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    return segments.isNotEmpty ? segments.last : path;
  }
}
