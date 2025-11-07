import 'package:flutter/material.dart';

/// Global navigation keys for the application
class NavigationKeys {
  /// Main navigator key for the root navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Shell route navigator key for cards section
  static final shellRouteCardsKey = GlobalKey<NavigatorState>();

  /// Shell route navigator key for shortcuts section
  static final shellRouteShortcutsKey = GlobalKey<NavigatorState>();
}
