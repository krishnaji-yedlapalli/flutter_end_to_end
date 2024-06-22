
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/ui/schools/create_update_student.dart';

main() {

  group('create student widget test', () {

    testWidgets('create new student', (tester) async {

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body : CreateStudent('124'))));
      await tester.pumpAndSettle();

      /// checking validation
      await tester.tap(find.text('Create'));
      await tester.pump();

      expect(find.text('Student name is required!!'), findsOneWidget);
      expect(find.text('Standard is required!!'), findsOneWidget);
      expect(find.text('Location is required!!'), findsOneWidget);

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

      expect(find.text('Create'), findsOneWidget);
    });


    testWidgets('Edit existing student', (tester) async {

      await tester.pumpWidget(MaterialApp(home: Scaffold(body : CreateStudent('123', student:
      StudentModel('321', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211)))));
      await tester.pumpAndSettle();

      expect(find.text('john'), findsOneWidget);
      expect(find.text('texas'), findsOneWidget);
      expect(find.text('LKG'), findsOneWidget);

      var studentTextFieldList = find.byType(TextFormField);
      await tester.enterText(studentTextFieldList.first, 'Joseph');
      await tester.enterText(studentTextFieldList.last, 'washington');
      await tester.pump();

      expect(find.text('Joseph'), findsOneWidget);
      expect(find.text('washington'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text('Update'), findsOneWidget);
    });
  });
}