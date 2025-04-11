import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_bloc.dart';
import 'package:sample_latest/features/schools/data/model/student_model.dart';
import 'package:sample_latest/features/schools/data/repository/school_repository.dart';
import 'package:sample_latest/features/schools/presentation/screens/student/create_update_student.dart';
import 'package:sample_latest/features/schools/presentation/screens/school_details/school_details.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

import '../../mock_data/configuration_data.dart';

main() {

  group('create student widget test', () {

    setUp((){
      DeviceConfiguration.initiate();
    });

    testWidgets('create new student', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateStudent('124'))));
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
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: CreateStudent('123',
                  student: StudentModel(
                      '321', '123', 'john', 'texas', 'LKG', 1234567,
                      updatedDate: 432211)))));
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

    testWidgets('Testing different Screen resolution', (tester) async {

      for (var size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);
        DeviceConfiguration.updateDeviceResolutionAndOrientation(size, Orientation.portrait);

        await tester.pumpWidget(MaterialApp(
            key: UniqueKey(),
            home: MediaQuery(
                data: MediaQueryData(size: size),
                child:  BlocProvider(
                    create: (context) => SchoolBloc(SchoolRepository()),
                    child: SchoolDetails('123', null)))));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        /// checking validation
        await tester.tap(find.text('Create'));
        await tester.pump(const Duration(seconds: 2));

        expect(find.text('Student name is required!!'), findsOneWidget);
        expect(find.text('Standard is required!!'), findsOneWidget);
        expect(find.text('Location is required!!'), findsOneWidget);

        var studentTextFieldList = find.byType(TextFormField);
        await tester.enterText(studentTextFieldList.first, 'Joseph');
        await tester.enterText(studentTextFieldList.last, 'Texas');
        await tester.pump();
      }
    });
  });
}
