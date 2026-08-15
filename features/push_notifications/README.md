# Push Notifications

A feature module demonstrating Firebase Cloud Messaging (FCM) for remote push notifications and `flutter_local_notifications` for local notification delivery across mobile, desktop, and web platforms.

## Overview

The Push Notifications feature showcases how to integrate both remote and local push notification systems in a Flutter application. It demonstrates:

- **Firebase Cloud Messaging (FCM)** — receiving remote push notifications with foreground/background handling
- **Local Notifications** — displaying notifications locally via `flutter_local_notifications`
- **Permission Handling** — requesting and managing notification permissions per platform
- **Token Management** — retrieving and refreshing FCM registration tokens (including VAPID key for web)
- **Deep Link Navigation** — handling notification taps to navigate to specific app routes
- **Service Account Auth** — sending push notifications via the FCM HTTP v1 API using `googleapis_auth`

The feature provides a UI for testing end-to-end push notification flows: requesting permissions, copying the device token, composing a message, and sending it back to the same device via FCM.

## Architecture

This module uses a **flat, presentation-focused structure** without full Clean Architecture layering. Since push notifications are primarily a platform integration concern rather than a domain-logic feature, the code is organized as service classes and UI widgets.

### Key Components

- **`PushNotificationService`** — Static service class that centralizes:
  - Firebase configuration options per platform
  - FCM foreground message listeners
  - Local notification initialization and display
  - Notification tap handling and deep-link navigation
- **`FirebasePushNotifications`** — Stateful widget providing the remote notification UI (permission requests, token display, message composition and sending)
- **`LocalPushNotifications`** — Stateful widget for local notification demonstrations
- **`NotificationWithRemoteAndLocal`** — Shell widget with bottom navigation to switch between remote and local notification views

### Notification Flow

```
FCM Server → Firebase → Device
  │
  ├─ Foreground: onMessage listener → show local notification via FlutterLocalNotificationsPlugin
  ├─ Background: onMessageOpenedApp → navigate to route from payload
  └─ Terminated: getInitialMessage → navigate on cold start
```

## Directory Structure

```
push_notifications/
├── lib/
│   ├── firebase_push_notifications.dart   # Remote notification UI and FCM HTTP v1 sender
│   ├── local_pushNotifications.dart       # Local notification demonstration widget
│   ├── notifications.dart                 # Shell widget with bottom navigation
│   └── push_notification_service.dart     # FCM setup, local notification init, Firebase options
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_messaging` | FCM registration, token management, message listeners |
| `flutter_local_notifications` | Local notification display on Android, iOS, macOS |
| `googleapis_auth` | Service account authentication for FCM HTTP v1 API |
| `go_router` | Navigation between remote/local notification views |
| `app_core` | Shared infrastructure (device config, routing, notification navigation handler) |

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ | Full FCM + local notifications |
| iOS      | ✅ | FCM via APNs + local notifications |
| Web      | ✅ | FCM with VAPID key; toast notifications in browser |
| macOS    | ✅ | FCM via APNs + local notifications |
| Linux    | ❌ | Firebase not configured for Linux |
| Windows  | ❌ | Firebase not configured for Windows |

## Usage

### Navigating to Push Notifications

The feature is accessible from the app's home screen. The route path is:

```
https://flutter-end-to-end.web.app/home/push-notifications/remote-notifications
```

### Sub-routes

```
/home/push-notifications/remote-notifications  → FCM remote notification UI
/home/push-notifications/local-notifications   → Local notification UI
```

### FCM Setup

The module initializes FCM listeners on app startup:

```dart
PushNotificationService.initiateTheFirebaseListeners();
PushNotificationService.initializeLocalPushNotifications();
```

### Sending a Test Notification

1. Navigate to the remote notifications tab
2. Request notification permissions
3. Copy the FCM registration token
4. Fill in the message title, body, and target page route
5. Tap "Send Push Notification" to send via FCM HTTP v1 API

### Notification Navigation

Notifications include a `path` data field. When tapped, the app navigates to the specified route using `NotificationNavigationHandler` from the core package.

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Web Demo](https://flutter-end-to-end.web.app/)
- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [flutter_local_notifications Package](https://pub.dev/packages/flutter_local_notifications)
- [FCM HTTP v1 API Reference](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send)
