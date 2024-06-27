
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/notifiers.dart';
import 'package:sample_latest/routing.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class PushNotificationService {

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtodL7DA8dz3B5HEMuJ7di0DY2MEQOjws',
    appId: '1:334267766183:web:a26cc63b3cc29fe3a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    authDomain: 'flutter-end-to-end.firebaseapp.com',
    storageBucket: 'flutter-end-to-end.appspot.com',
    measurementId: 'G-NJEW95MV5Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYUkLiGg_EsknSReddn1ZVijODPdEwqGw',
    appId: '1:334267766183:android:986bb1f13deca8c4a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt0ks4rwqe2wAy3xrUszvQOY-s48yignA',
    appId: '1:334267766183:ios:d93d9771baaabea8a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
    iosBundleId: 'com.example.sampleLatest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBt0ks4rwqe2wAy3xrUszvQOY-s48yignA',
    appId: '1:334267766183:ios:a241a09460830bcda35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
    iosBundleId: 'com.example.sampleLatest.RunnerTests',
  );

  static AuthClient? credentials;

  static void initiateTheFirebaseListeners() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
      print('Message notification: ${message.data}');

      showNotification(title: '${message.notification?.title}', body: '${message.notification?.body}', payLoad: message.data);

    }).onError((e) => debugPrint('Failed to on omessage ${e.toString()}'));

    FirebaseMessaging.onMessageOpenedApp
        .listen(Routing.onPushNotificationOpened);

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      Routing.onPushNotificationOpened(initialMessage);
    }
  }

  static void initializeLocalPushNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('dash_desktop');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: handleLocalPushNotification);
  }

  static notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  static handleLocalPushNotification(NotificationResponse notificationResponse) async {
    if(notificationResponse.payload != null){
      Routing.onLocalPushNotificationOpened(notificationResponse.payload);
    }
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, Map<dynamic, dynamic>? payLoad}) async {

    if(DeviceConfiguration.isWeb && navigatorKey.currentState?.context != null){
      Notifiers.toastNotifier('${title ?? 'Title Missing'} \n ${body ?? 'No Body'}');
    }else {
      await flutterLocalNotificationsPlugin.show(
          id, title, body, await notificationDetails(),
          payload: payLoad?['path']);

      if(DeviceConfiguration.isiPhone) {
        Future.delayed(const Duration(milliseconds: 800), () => flutterLocalNotificationsPlugin.cancel(0));
      }
    }

  }

  static void deleteToken() async => await FirebaseMessaging.instance.deleteToken();
}