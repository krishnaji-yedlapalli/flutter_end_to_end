

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sample_latest/core/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/features/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/core/utils/connectivity_handler.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    ConnectivityHandler().initialize();
    await Firebase.initializeApp(
      options: PushNotificationService.currentPlatform,
    );
    Environment().configure();
    DeviceConfiguration.initiate();
  });


  group('end to end test', (){
    testWidgets('end to end test', (tester) async {

      await tester.pumpWidget(const MyApp());

      bool homeOverlayDismissed = false;
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100)); // Pump for a short duration

        // Check if the overlay is dismissed
        if(find.text('Dismiss').evaluate().isNotEmpty) {
          final homeDismiss = find.text('Dismiss');
          homeOverlayDismissed = true;
          await tester.tap(homeDismiss);
        }
        if (homeOverlayDismissed) {
          break;
        }
      }
      // await Future.delayed(Duration(seconds: 4));
      await tester.pumpAndSettle();

      var school = find.byKey(const Key('school'));
      await tester.tap(school);

      bool schoolOverlayDismissed = false;
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100)); // Pump for a short duration

        // Check if the overlay is dismissed
        var schoolDismiss = find.text('Dismiss');
        if(schoolDismiss.evaluate().isNotEmpty && tester.any(schoolDismiss)) {
          await tester.ensureVisible(schoolDismiss);
          if(i < 30) continue;
          schoolOverlayDismissed = true;
          await tester.tap(find.text('Dismiss'));
        }
        if (schoolOverlayDismissed) {
          break;
        }
      }

      await tester.pumpAndSettle();


      var welcomePopup = find.byIcon(Icons.thumb_up);
      await tester.tap(welcomePopup);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 1));

      /// checking validation
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      var textFieldList = find.byType(TextFormField);

      await tester.enterText(textFieldList.first, 'Kennedy');
      await tester.enterText(textFieldList.last, 'Hyderabad');
      await tester.pump();

      var dropDown = find.text('Select Country');
      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      var selectDropDownItem = find.text('India');
      await tester.tap(selectDropDownItem);
      await tester.pump();

      await tester.tap(find.text('Create'));
      await tester.pump(const Duration(seconds: 2));

      var createdSchool = find.byType(ListTile);

      var edit = find.descendant(of: createdSchool.first, matching: find.byIcon(Icons.edit));
      await tester.tap(edit);
      await tester.pumpAndSettle();

      var editTextFieldList = find.byType(TextFormField);

      await tester.enterText(editTextFieldList.first, 'Oxford');
      await tester.enterText(editTextFieldList.last, 'San Francisco');

      await tester.tap(find.text('Update'));
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      var studentTextFieldList = find.byType(TextFormField);
      await tester.enterText(studentTextFieldList.first, 'Joseph');
      await tester.enterText(studentTextFieldList.last, 'Texas');
      await tester.pump();


      var studentDropDown = find.text('Standard');
      await tester.tap(studentDropDown);
      await tester.pumpAndSettle();

      var selectStandardDropDownItem = find.text('LKG');
      await tester.tap(selectStandardDropDownItem.last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      var editStudent = find.descendant(of: createdSchool.first, matching: find.byIcon(Icons.edit));
      await tester.tap(editStudent);
      await tester.pumpAndSettle();

      var editStudentTextFieldList = find.byType(TextFormField);
      await tester.enterText(editStudentTextFieldList.first, 'Amar');
      await tester.enterText(editStudentTextFieldList.last, 'Washington');
      await tester.pump();

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      var student = find.byType(ListTile);

      await tester.tap(student.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      var deleteSchool = find.descendant(of: find.byType(ListTile).first, matching: find.byIcon(Icons.delete));
      await tester.tap(deleteSchool);
      // await tester.pump(const Duration(seconds: 1));

    });
  });
}