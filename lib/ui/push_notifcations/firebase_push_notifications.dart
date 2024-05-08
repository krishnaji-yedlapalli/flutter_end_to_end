
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
        credentials = await obtainAuthenticatedClient();
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
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": "a86a1a9766f846307177079d20b1e32568a0e905",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1jp0R8FCkN8Fz\na1HkaMlyXRQlY71x2YVfaA75d/lRHDCWXyGIqlTNWctbAYKux/aoXiLAfwZLpyo1\ngbUrM1lWU9ZTx6uvBJxys9cSr4tTzGO6HzLsNvohby6DP1XicDstw4aiD0/p+3tz\nVztd8efuXJZpZzFmUshOirCe0qcDAE/k25fxm68knsxjYCL/K1ieyXdDLVBevr9z\nszzXk23vATMcPVcOwXM9ZuZn7PUj1tRM+TAwKvzJVuZxtHSHgG4fGlYCrFtboYLD\n+F2j74ay/V0I9fi7kDn0wjT0pFtBiBWQOM2B8o+/zhqbawGNKe4z3pD0b0NE4YE1\nrnSX7URBAgMBAAECggEAQyFAImng51dWR/7egL3d/lM8J7cBTR9ImUY4gzVBEiSC\nMpdqJsYUJPmWn0enskhtg0OLRfGxujdM/AvBmP+bgLfu/3tMl6H01tR4KYiO06U3\nGpJ+maiaQ9KAODcq4lbtCrbJCRLwUWuS8crHQK05PIEvfDmTomnpdmEBfTgWWJ0c\npMS7mXM6SZitNqtzYd2v7ufUn3gSYorLpxFn1uw6czb0z/oJQo87wvX8XNbgkJ8U\nN38CtyXOxS8zWR7UirXgLYLDlEYf0z1M3DuY/AeuAI22R3NJx2YgYCzrvEtyah+n\nfXU3cVbzgjtUb33S2iy0totW3zGHoTYx81/mxcLDIQKBgQDvGnet12O/A2sFtLls\n0pMnBO2jyaiB+EMsnZF0BTXBNm+g2oMF3iwNxb5u9GUvXZ3K00jHmhJL8YOV4tFb\nlhD0BKqupIDbynlEbr+l1P3X6cNoTE00JXXUXiU6Ni+p7nzQoinelWOdFOaQsJSs\n/44FmTgXmc7zHau6kScQegngqwKBgQDCYxjGikywhb7RbDbf9CBUoHQWVaJeDOzY\nNGYV0Ap/AOZXRo6xkwo3Nrsm4JtSwLul7h5XR6jlzZ7TDElNaVau4+Rb/UvTI6eG\nJ9TZXYQgy86h8N+wx/gARWvrLhxNXgJgxCxLD+c3Xewd4CoPrB/EDwdbaJEydX7D\nwKc7JqlmwwKBgQC9oLgZ3yD0dLmEJPiKHdcmsvnlVCGYMlTUJYMeCKPBQHL3l1Ui\najl2EsYdKSa2kgB6w2aNJtwr7rb1QJXZlQKNBMZ5C25G4iWa6FqGIo3Pl02qghkY\nqjzw2Fmd+SuEEehbbsDWDpSaF+FkDydarLLuLb4WuZ0vovB3Xnck0iTTUQKBgQC0\n1QlMUYYMRS+BlQDrkCivcWDtEhbtFWsTqpM5QYMyKP0fPcUrDpXXTXQHM7Vq417t\neroBCenmdkWFIg3jFNaN9fUPWnC6Z5XFqLJKz8NF2zNL1U/THgPpBKvjac7sbkMa\nEAUAgzfeeuJX3JxkXgRjGHQIphtE7KbTphosXcgDjwKBgAsROjguI/NrqtMnyPii\nN3IlWMSSZvqDm0NsF7eM9tWRS98QkZa1JF5++o6iVB21+VdH0zBou8qzCjNmq14P\nEt8wxIIVWsgCX8S8Qki1OnajifoJWYzn9EYA2I/T7MX6e5ofP/QjkKNiZsVATgUq\nPIt0QrLmJb4Yfq+Sp8Xhops4\n-----END PRIVATE KEY-----\n",
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