import 'package:sample_latest/core/firebase/services/firebase_service.dart';

/// Abstract contract for Firebase Cloud Messaging (FCM).
///
/// Manages push notification token lifecycle and message handling.
abstract class FirebaseMessagingService extends FirebaseService {
  /// Gets the current FCM token.
  Future<String?> getToken();

  /// Deletes the current FCM token.
  Future<void> deleteToken();

  /// Requests notification permissions from the user.
  Future<bool> requestPermission();

  /// Subscribes to a topic.
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribes from a topic.
  Future<void> unsubscribeFromTopic(String topic);

  /// Stream of foreground messages.
  Stream<Map<String, dynamic>> get onMessage;

  /// Stream of messages that opened the app from background/terminated.
  Stream<Map<String, dynamic>> get onMessageOpenedApp;
}
