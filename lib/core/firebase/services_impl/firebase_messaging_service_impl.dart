import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sample_latest/core/firebase/services/firebase_messaging_service.dart';

/// Concrete implementation of [FirebaseMessagingService].
class FirebaseMessagingServiceImpl extends FirebaseMessagingService {
  FirebaseMessagingServiceImpl();

  late final FirebaseMessaging _messaging;
  bool _isInitialized = false;

  final StreamController<Map<String, dynamic>> _onMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _onMessageOpenedAppController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _onMessageController.add({
        'messageId': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onMessageOpenedAppController.add({
        'messageId': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
      });
    });

    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    await _onMessageController.close();
    await _onMessageOpenedAppController.close();
    _isInitialized = false;
  }

  @override
  Future<String?> getToken() async {
    if (!_isInitialized) return null;
    return await _messaging.getToken();
  }

  @override
  Future<void> deleteToken() async {
    if (!_isInitialized) return;
    await _messaging.deleteToken();
  }

  @override
  Future<bool> requestPermission() async {
    if (!_isInitialized) return false;
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (!_isInitialized) return;
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isInitialized) return;
    await _messaging.unsubscribeFromTopic(topic);
  }

  @override
  Stream<Map<String, dynamic>> get onMessage => _onMessageController.stream;

  @override
  Stream<Map<String, dynamic>> get onMessageOpenedApp =>
      _onMessageOpenedAppController.stream;
}
