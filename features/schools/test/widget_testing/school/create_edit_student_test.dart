import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schools/presentation/screens/student/create_update_student.dart';
import 'package:schools/shared/models/student_view_model.dart';

void main() {
  setUp(() {
    DeviceConfiguration.initiate();
    DeviceConfiguration.updateDeviceResolutionAndOrientation(
        const Size(375, 667), Orientation.portrait);
  });

  Future<void> pumpCreateStudent(WidgetTester tester, String schoolId,
      {StudentViewModel? student}) async {
    final parentKey = GlobalKey();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          key: parentKey,
          builder: (ctx) => CreateStudent(ctx, schoolId, student: student),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  group('create student widget test', () {
    testWidgets('create new student - validation', (tester) async {
      await pumpCreateStudent(tester, '124');

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
      final student = StudentViewModel(
        id: '321',
        schoolId: '123',
        studentName: 'john',
        studentLocation: 'texas',
        standard: 'LKG',
      );

      await pumpCreateStudent(tester, '123', student: student);

      expect(find.text('john'), findsOneWidget);
      expect(find.text('texas'), findsOneWidget);

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
