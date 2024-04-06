
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
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
      onSelectionChanged: (selection){
        if(selection != null && selection.plainText.trim().isNotEmpty){
          if (kIsWeb) {
            BrowserContextMenu.enableContextMenu();
          }
        }else if(selection != null){
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
                      style : const TextStyle(color: Colors.deepOrangeAccent),
                    children: [
                      const TextSpan(text: 'Authorization Status :'),
                      TextSpan(text: '$authorizationStatus', style : Theme.of(context).textTheme.titleMedium)
                    ]
                )),
                ElevatedButton(onPressed: _requestPermissions, child: const Text('Request Notification Permissions')),
              ],
            ),
            Divider(),
            Column(
              // direction: Axis.vertical,
              children: [
                RichText(text: TextSpan(
                    style : const TextStyle(color: Colors.deepOrangeAccent),
                    children: [
                    const TextSpan(text: 'Token : '),
                    TextSpan(text: '$token', style : Theme.of(context).textTheme.titleMedium?.apply(overflow: TextOverflow.fade), )
                  ]
                )),
                ElevatedButton(onPressed: copyToClipBoard, child: const Text('Copy registration token'))
              ],
            ),
            // Divider(),
            // ElevatedButton.icon(onPressed: DefaultFirebaseOptions.deleteToken, label: const Text('Delete Token'), icon: Icon(Icons.delete)),
            Divider(),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(controller: tokenCtrl, label: 'Paste the Registration Token', suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: ()=> tokenCtrl.clear()), validator: (val) => textEmptyValidator(val, 'Token required')),
                  CustomTextField(controller: titleCtrl, label: 'Message Title', validator: (val) => textEmptyValidator(val, 'Message Title required')),
                  CustomTextField(controller: bodyCtrl, label: 'Message Body', validator: (val) => textEmptyValidator(val, 'Message Body required')),
                  CustomTextField(controller: pageCtrl, label: 'Page Navigation', validator: (val) => textEmptyValidator(val, 'Page navigation is required')),
                  ElevatedButton(onPressed: requestPushNotification, child: const Text('Send Push Notification'))
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

    if(token != null) {
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

  Future<String?> get registrationToken async  {

    if(kIsWeb){
      return await messaging.getToken(vapidKey: 'BMpLBUNBcXKWFOfv7eM5f5QDD5h1HRf4s7XPWw_y2z9T4ZdgsAYmeRCpNCe_6cdDHjqkCJ6eg8udxR1qPU8N82c');
    }else {
      if(Platform.isIOS || Platform.isMacOS){
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          return await messaging.getToken();
        }
      }
      return await messaging.getToken();
    }
  }


  void requestPushNotification() async {
    try{

      if(!(formKey.currentState?.validate() ?? true)) return;

      var body = {
        "to": tokenCtrl.text.trim(),
        "notification": {
          "title": titleCtrl.text.trim(),
          "body": bodyCtrl.text.trim(),
          "mutable_content": true,
          "sound": "Tri-tone"
        },
        "data" : {
          "path" : pageCtrl.text.trim()
        }
      };

      var headers = {
       'Authorization' : 'key=AAAATdPpVac:APA91bEgi5Czf7j9SZKHCqf6ehuH2_JzuMPeAsXz8hpALan9-NxIGp-wuPz3RcNiD0Izi4j3tOd5Alm7v26VZSfpw1XTrCRVmdURcxDOcPEcJEsflupI94Ehx4t259uHX64Qkc9r5M7r'
      };

      var res = await makeRequest(url: 'fcm/send', baseUrl: 'https://fcm.googleapis.com/', body: body, headers: headers, method: RequestType.post);
      if(res != null && res['success'] == 1){
        var snack = const SnackBar(content: Text('Successfully sent the message!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    }catch(e,s){

    }
  }
}