
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:sample_latest/core/extensions/widget_extension.dart';
import 'package:sample_latest/core/mixins/validators.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/core/widgets/text_field.dart';

class FirebasePushNotifications extends StatefulWidget {
  const FirebasePushNotifications({Key? key}) : super(key: key);

  @override
  State<FirebasePushNotifications> createState() => _FirebasePushNotificationsState();
}

class _FirebasePushNotificationsState extends State<FirebasePushNotifications> with Validators {

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

      var res = await BaseService.instance.makeRequest(url: 'v1/projects/flutter-end-to-end/messages:send',
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
      "private_key_id": "895d76ff9756d8e17772c406114f0a2232103808",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCKK7ErGbIuCVej\nZk5I9RAdtE9BVbE0XYTc0uRmwij6IDFPdkdBkkpShjoSlZf2j0AXDd0WMbArsbM/\nnaO8aVQVrVcnaGryb753P59hCae4xLS+eAJHJLz1TLCkh6yqbQ+PM+IBEYPcJOAQ\nQfR7PmaeR2XE/ElvokxESZZ2CbuI+sRnzcr1Hk8Bp0PbG6ERwqrCoH7DJV/M2QtF\nuDZ+waa3eirpdZ4FLaDeL5Wyut11jo0174TgzhB/7K6lkrZ31NkrygmpsY8d6wHd\nCccC9lZWOSBldV8NTapj6qXZU6Ooa7P/fSDKfrhyXG99V7effd6MfspDFA18vJeA\no387m4HnAgMBAAECggEAAQ7wnnnl6YBc0X2ZH+nwo6mb6c40O0h0GhTrdvYJxlC0\nz/0B8riiJRuuGjJXJaZXQVXz2ZWr2cnUq6oTdQABiuD3B/A+0XiVpugv2lhulnW7\nRLI6ojzfzak2uSvo4K1RLzGgi42MywTlSnqW2tLRimjVmLqt/VLq7qL5qhHNA/GU\n6et3wG1Xer6QtPxqrjUHl6518NH4QTHw67GSrSPv+F+EgvCpX7aAH6vJVhDQPx2Y\nn7sXLF7lzW9RYYQq+Oe8g3P4Y+eQRq/JMKo41xU7yUK2I5m8mBo/IdGQBFCj9yyh\nxr4cfqGP/+HV6ifrOVwQK821sAJRe6M1inWnWCeDoQKBgQC98ZOrMo5lwwToa+XK\n25Aq9VcwXqiZCWXq5rX1MRfHM057vRWW8r3JgU6PcEK1yEZH6T7qJgU39EvXmfyq\nkqHpBJW4KrfYk2ISDhKt4lVtOnI4bJBjSdbAFk9XyKq6BFzPvAAXQg58UVkHLYwu\nWFVBIecXvNLM4n+DNGouP+f1iQKBgQC6ONZW46l07gmmHhBFEJunN1S3z5/s7Sqn\nL9c60fCzgFomRUZemBxKhr3VYP2a9sv5JhQYdF+0rbv2PMW7y1buhtSGmH87ANBk\n3pBWrVcIeVsZygqfCGPtVGRQKtevmY3lmj0r1Oc+c7X/Q6QTVc0PtyW5zqqQLcYq\n56mbiQhP7wKBgB299Bd8hRueG+ig7IyFMN/pJsvmJpRACntrwNYx571DZWiuxPCr\n9dfVrY18UJXSVF7yQO29IlgOosmRzSSQbVXlZ+Q8nCkHevXEylv78tB1tGjtZvaF\nG2FcnPPr8f/KqxXEJGd/6nDA9CXRlf+zyTW3r03iPUfjt3+991pim1mxAoGBAIDg\nzRYdQS23f94DeGcT82VqmasMejXSfW5vYZlHqjnQXpOV5fmZdBrv3XlLQrh4jPnF\nLKsv/vxgMHFd5cruEx/JGFR+Pa9sBM2KaoJSPKWUt0PF3Evr1pxth28j91mD//wj\nHqqzEcba9d3PxkHLY7u4mNda/BgEVd1jrrIByErpAoGARG+R1K6sXOUEe/fYDiEh\nO3gKOEryZ0+cJcxh9CNYAv6eCEjqN69iGVddLvPgdGyt5cpmd5gqkNiNCCuHzqNX\nJkvGTPuj/stsu7XW/gNOXzeTZHr598sL7Lwd6BoOS2WWRQEH8Qr/QmtWC2QSjqug\n21a7+PJ7/GSN9S4YX8Mgcc4=\n-----END PRIVATE KEY-----\n",
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