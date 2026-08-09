import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

import 'navigation_keys.dart';

/// Handles navigation when push notifications are opened.
/// The main app registers its callbacks via [register].
class NotificationNavigationHandler {
  static void Function(RemoteMessage?)? _onRemoteNotificationOpened;
  static void Function(String?)? _onLocalNotificationOpened;

  /// Register handlers from the main app's routing layer.
  static void register({
    required void Function(RemoteMessage?) onRemoteOpened,
    required void Function(String?) onLocalOpened,
  }) {
    _onRemoteNotificationOpened = onRemoteOpened;
    _onLocalNotificationOpened = onLocalOpened;
  }

  /// Called when a remote push notification is opened.
  static void onPushNotificationOpened(RemoteMessage? message) {
    if (_onRemoteNotificationOpened != null) {
      _onRemoteNotificationOpened!(message);
    } else {
      // Default fallback
      String path = '/home/schools';
      if (message?.data['path'] != null) path = message?.data['path'];
      if (NavigationKeys.navigatorKey.currentContext != null) {
        GoRouter.of(NavigationKeys.navigatorKey.currentContext!).push(path);
      }
    }
  }

  /// Called when a local push notification is opened.
  static void onLocalPushNotificationOpened(String? path) {
    if (_onLocalNotificationOpened != null) {
      _onLocalNotificationOpened!(path);
    } else {
      // Default fallback
      path ??= '/home/schools';
      if (NavigationKeys.navigatorKey.currentContext != null) {
        GoRouter.of(NavigationKeys.navigatorKey.currentContext!).push(path);
      }
    }
  }
}
