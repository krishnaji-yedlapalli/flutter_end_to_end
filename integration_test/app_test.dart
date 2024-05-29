

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import '';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end to end test', (){
    testWidgets('end to end test', (tester) async {


      // IntegrationTestWidgetsFlutterBinding();
      ConnectivityHandler().initialize();
      await Firebase.initializeApp(
        options: PushNotificationService.currentPlatform,
      );
      Environment().configure();
      DeviceConfiguration.initiate();

      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle(Duration(seconds: 2));

     // expect(find.text('hello John Carte'),  findsOne);

      // await tester.pumpAndSettle(const Duration(seconds: 2));


      //
     //  expect(find.text('hello John Carte'),  findsNothing);
     //  expect(find.text('hello John Carte'),  findsNothing);
     //
      final schoolTile = find.byKey(Key(ScreenType.school.name));
     //
     await tester.tap(schoolTile);

      await tester.pumpAndSettle(Duration(seconds: 2));

      // final addButton = find.byIcon(Icons.add);
      //
      // await tester.tap(addButton);
      //
      // await tester.pumpAndSettle(Duration(seconds: 2));

      final dismiss = find.text('Dismiss');

      await tester.tap(dismiss);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final createSchool = find.text('Create School');

      await tester.tap(createSchool);

      await tester.pumpAndSettle(Duration(seconds: 2));

    });
  });
}