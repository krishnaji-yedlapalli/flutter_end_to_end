
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/services/base_service.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/widgets/text_field.dart';

class FirebasePushNotifications extends StatefulWidget {
  const FirebasePushNotifications({Key? key}) : super(key: key);

  @override
  State<FirebasePushNotifications> createState() => _FirebasePushNotificationsState();
}

class _FirebasePushNotificationsState extends State<FirebasePushNotifications> with BaseService, Validators {

  final messaging = FirebaseMessaging.instance;
  String? authorizationStatus = AuthorizationStatus.notDetermined.name;
  String? token;
  final tokenCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final pageCtrl = TextEditingController(text: '/home/schools');
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      setState(() {
        tokenCtrl.text = token = fcmToken;
      });
    })
        .onError((err) {
      // Error getting token.
    });

    copyToClipBoard();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      onSelectionChanged: (selection) {
        if (selection != null && selection.plainText
            .trim()
            .isNotEmpty) {
          if (kIsWeb) {
            BrowserContextMenu.enableContextMenu();
          }
        } else if (selection != null) {
          if (kIsWeb) {
            BrowserContextMenu.disableContextMenu();
          }
        }
      },
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          children: [
            Column(
              children: [
                RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.deepOrangeAccent),
                        children: [
                          const TextSpan(text: 'Authorization Status :'),
                          TextSpan(text: '$authorizationStatus', style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium)
                        ]
                    )),
                ElevatedButton(onPressed: _requestPermissions,
                    child: const Text('Request Notification Permissions')),
              ],
            ),
            const Divider(),
            Column(
              // direction: Axis.vertical,
              children: [
                RichText(text: TextSpan(
                    style: const TextStyle(color: Colors.deepOrangeAccent),
                    children: [
                      const TextSpan(text: 'Token : '),
                      TextSpan(text: '$token', style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.apply(overflow: TextOverflow.fade),)
                    ]
                )),
                ElevatedButton(onPressed: copyToClipBoard,
                    child: const Text('Copy registration token'))
              ],
            ),
            // Divider(),
            // ElevatedButton.icon(onPressed: DefaultFirebaseOptions.deleteToken, label: const Text('Delete Token'), icon: Icon(Icons.delete)),
            const Divider(),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(controller: tokenCtrl,
                      label: 'Paste the Registration Token',
                      suffixIcon: IconButton(icon: const Icon(Icons.clear),
                          onPressed: () => tokenCtrl.clear()),
                      validator: (val) =>
                          textEmptyValidator(val, 'Token required')),
                  CustomTextField(controller: titleCtrl,
                      label: 'Message Title',
                      validator: (val) =>
                          textEmptyValidator(val, 'Message Title required')),
                  CustomTextField(controller: bodyCtrl,
                      label: 'Message Body',
                      validator: (val) =>
                          textEmptyValidator(val, 'Message Body required')),
                  CustomTextField(controller: pageCtrl,
                      label: 'Page Navigation',
                      validator: (val) =>
                          textEmptyValidator(
                              val, 'Page navigation is required')),
                  ElevatedButton(onPressed: requestPushNotification,
                      child: const Text('Send Push Notification'))
                ],
              ),
            ),
          ],
        ).screenPadding(),
      ),
    );
  }

  void copyToClipBoard() async {
    token = await registrationToken;

    debugPrint('token : $token');

    if (token != null) {
      tokenCtrl.text = token!;

      await Clipboard.setData(ClipboardData(text: token ?? ''));

      var snack = const SnackBar(content: Text('Token Copied'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
      setState(() {});
    }
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

    setState(() {
      authorizationStatus = settings.authorizationStatus.name;
    });
    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
  }

  Future<String?> get registrationToken async {
    if (kIsWeb) {
      return await messaging.getToken(
          vapidKey: 'BELYPbF8fCnMJeNmbTSl3uJbvXlKj3kG_C7XqYDvoYZuwrK7_EZ7RAgaHqD3MGkFveq6GlkYIYxuFlJlERf0oLo');
    } else {
      if (Platform.isIOS || Platform.isMacOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          return await messaging.getToken();
        }
      }
      return await messaging.getToken();
    }
  }


  void requestPushNotification() async {
    try {
      if (!(formKey.currentState?.validate() ?? true)) return;

      var body = {
        "message": {
          "token": tokenCtrl.text.trim(),
          "notification": {
            "title": titleCtrl.text.trim(),
            "body": bodyCtrl.text.trim()
          },
          "data": {
            "path": pageCtrl.text.trim()
          }
        }
      };

      AuthClient? credentials;
      if (PushNotificationService.credentials == null) {
        PushNotificationService.credentials = credentials = await obtainAuthenticatedClient();
      } else {
        credentials = PushNotificationService.credentials;
      }

      var headers = {
        'Authorization': '${credentials?.credentials.accessToken
            .type} ${credentials?.credentials.accessToken.data}'
      };

      var res = await makeRequest(url: 'v1/projects/flutter-end-to-end/messages:send',
          baseUrl: 'https://fcm.googleapis.com/',
          body: body,
          headers: headers,
          method: RequestType.post);
      if (res != null && res['success'] == 1) {
        var snack = const SnackBar(
            content: Text('Successfully sent the message!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    } catch (e) {
      var snack = const SnackBar(
          content: Text('Failed to sent the message!!!'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    /// https://console.firebase.google.com/u/0/project/flutter-end-to-end/settings/serviceaccounts/adminsdk
    /// Generate New private key
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": "f9990bf50ca2cf1ab8dda019f0cf91f2f71e2a42",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6bbU+1FqxBUUV\n7pXLSrrqBIJJ3+HdyG3wTOG3a57iIqWdCpuorgVlIVJEWuidicLbQt5m3owWetH1\nhslU4seSHFCm1lgC9WZMFEqtP5P/T+f9GPTLYg6RB/LOzcN9R02H33bqj5iZER04\no/18+lnghr3r/hFokNNrCnYCz/Xp+fXjnlJdDDt+tzkz6le8Tz99ZSdoAzZaTMmI\nBjgERIPQeIVBE/iafPYpEyZl9IRsbauHpYb/Mjh7bWEIv8pLaRgSKtoTIBxn+JCV\nV0ppzXtHIe18gm4XOBt2ScBJubbNRsvK8p0eKhYUuAzB8hXcZiB/mshrrjGIT/vK\nX5jOZUwRAgMBAAECggEAB34lTLMoOfkmP61pI9SLEqC/w8xVvZ4ynPfaEo8mwZv2\n4ArvGqZz3Q6ryceFld9Vj45udd/37WdeTOnv6ZN7xemRbEMtImFOjTw7jB8ECbzi\nbA+2tv3n6/hPz/QBKWXWPeHDW8YNsgk4DXC53W4KcrW3qGZ7uKIpfSHcgFxvW8n4\nfJma8bLjrXOCSXNjlcjHsIS2uZV7Kf9ffPQcp98xYWJWNYwGKj/eTXhcZHDQJOEY\nbmFa+UBe91XcaDQ2vF6tD9AZG2sFSny4AMXmFzF10d2IzCmHCIVbR43c0VjZMDR3\nEv7pjboDOdkUdRiOE4Ftc8FBzLzyelg0MF3iLx2MAQKBgQDl5td0Kj4kKoeDVvHx\nxxkNBLyUVpPi7eHzJYyDYl2NhNc7zUN1IR46P2lDEufST0RFj82LeYedPidWT/m7\nzC04p+rKYwu3bzkC/LJdbm7PMiFIfd3+Bul88g8lK+eBiFYw8fuinN0hyJ0D2+jA\nGcbuvqLEJW04t11PQgqSdAcw8QKBgQDPl37L/ohecHNhaJFGjGefARMrPVhQ8nz3\nAkus29etvDRHU1SGwIKkEXKAsfwd1LtATyQ+IspE9nA/ZIvYZv5PIv53JUdyoE3K\n4C+hQvIb6rCwfh/yruJeSD+fqgCc92pbiBp/NI/sV1mYh3gEsolUoKHy+ZhTRbRr\njcSLy7fNIQKBgQDi/0O64j7LLObyqrVneaNldEjS2o1YonLXxjpwO36Nzh1KYcj6\nbMHQ122Smaclw7hwSqWz0kIx4v2qPnshj18TMtEkFhmqe/o51dIzaGem0yOD1SuM\nt7xw7vw/QpNqFXitCTDhhardwZwvBEJS8uC2OKqzqxSlzH8oU9fmdQPosQKBgFK+\n9UjE5YCXXDZoove3AZrMp+Jlam2hqpQe8yEs5DSZP1Fq8tdfpvNVDQolZ/RQFm+U\n3EJ0RaHlhWqPXnrc2uOadEnzrx4OrdN/Nx0VfUIJc3J2Y6+tbAfezpWLAwGOUXO4\nta8cuX2gd9MntHxS2hDEkqkyOjh/IWJ5uO1sP5BhAoGAMnxig09/tklj7huc5pPy\niDH3nJev7dDGC7Vq6AQDKvr5kVILOHkBwF4banY7hK/DSQSBYpBKcUMeiz6yyPVk\nl7oaSNJ2gHu8hoMNWoHgZbtyvkTGfXE2Gr911ucQXflblZUt7oai6Wt0oDqviUJr\n5x9oLFPQ1FpSaqWJqXNvf+k=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-a5ioe@flutter-end-to-end.iam.gserviceaccount.com",
      "client_id": "108982530243471259982",
      "type": "service_account"
    });
    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    AuthClient client = await clientViaServiceAccount(
        accountCredentials, scopes);

    return client; // Remember to close the client when you are finished with it.

  }
}