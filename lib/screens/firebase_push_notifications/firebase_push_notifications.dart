
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class FirebasePushNotifications extends StatefulWidget {
  const FirebasePushNotifications({Key? key}) : super(key: key);

  @override
  State<FirebasePushNotifications> createState() => _FirebasePushNotificationsState();
}

class _FirebasePushNotificationsState extends State<FirebasePushNotifications> {

  final messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }

  void _requestPermissions() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
  }

  Future<String?> get registrationToken async  {

    await messaging.getToken(vapidKey: 'BP1oYbOt0v2U20ALouW2Uq2wU7xqhwR84l1cvG4aTwq1bF9-3FsVAUfL_VF8CwYcSxdX69GgcB9uPkAEYYBj3zM');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: _requestPermissions, child: Text('Request Notification Permissions')),
          ElevatedButton(onPressed: copyToClipBoard, child: Text('Copy registration token'))
        ],
      ),
    );
  }

  void copyToClipBoard() async {
    String? token = await registrationToken;
    print('token : $token');
    await Clipboard.setData(ClipboardData(text: token ?? ''));

    const SnackBar(content: Text('Token Copied'));
  }
}
