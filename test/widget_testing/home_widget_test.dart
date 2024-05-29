

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('home widget testing', () {

     setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      Environment().configure();
      DeviceConfiguration.initiate();
      await Firebase.initializeApp();
    });

    testWidgets('test home', (tester) async {

      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.school), findsWidgets);
      
      expect(find.text('Hello John Carter'), findsOne);

      var school = find.byKey(Key('school'));

      await tester.tap(school);

      await tester.pumpAndSettle(Duration(seconds: 1));

      var welcomePopup = find.byIcon(Icons.thumb_up);

      await tester.tap(welcomePopup);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      var addSchool = find.byIcon(Icons.add);

      await tester.tap(addSchool);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Create School'), findsAtLeast(2));

      var textFieldList = find.byType(TextFormField);

      await tester.enterText(textFieldList.first, 'Kennedy');
      await tester.enterText(textFieldList.last, 'Hyderabad');
      await tester.pump();

      // var dropDown = find.byType(DropdownButtonFormField);
      var dropDown = find.text('Select Country');
      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      var selectDropDownItem = find.text('UK');
      await tester.tap(selectDropDownItem);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();


    });
  });
}