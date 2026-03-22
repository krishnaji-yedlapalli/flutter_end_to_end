import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/features/schools/presentation/pages/schools/widgets/create_update_school.dart';
import 'package:sample_latest/features/schools/shared/models/school_view_model.dart';

import '../../mock_data/configuration_data.dart';

void main() async {
  setUp(() {
    DeviceConfiguration.initiate();
    DeviceConfiguration.updateDeviceResolutionAndOrientation(
        const Size(375, 667), Orientation.portrait);
  });

  Future<void> pumpCreateSchool(WidgetTester tester,
      {SchoolViewModel? school}) async {
    final parentKey = GlobalKey();

    final goRouter = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Builder(
            key: parentKey,
            builder: (ctx) => CreateSchool(parentContext: ctx, school: school),
          ),
        ),
      ),
    ]);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: goRouter,
      localizationsDelegates: TestConfigurationData.localizationDelegate,
      supportedLocales: TestConfigurationData.supportedLocales,
    ));
    await tester.pumpAndSettle();
  }

  group('Creating and editing a school', () {
    testWidgets('Creating school - validation', (tester) async {
      await pumpCreateSchool(tester);

      expect(find.text('Create School'), findsAtLeast(1));

      await tester.tap(find.text('Create'));
      await tester.pump();

      expect(find.text('School name is required!!'), findsOneWidget);
      expect(find.text('Country is required!!'), findsOneWidget);
      expect(find.text('Location is required!!'), findsOneWidget);

      var textFieldList = find.byType(TextFormField);

      await tester.enterText(textFieldList.first, 'Kennedy');
      await tester.enterText(textFieldList.last, 'Hyderabad');
      await tester.pump();

      var dropDown = find.text('Select Country');
      await tester.tap(dropDown);
      await tester.pumpAndSettle();

      var selectDropDownItem = find.text('India');
      await tester.tap(selectDropDownItem);
      await tester.pumpAndSettle();
    });

    testWidgets('Edit existing school', (tester) async {
      final school = SchoolViewModel(
          'Oxford', 'India', 'Noida', '52a29100b99c1023a3674150b7ab5f7b');

      await pumpCreateSchool(tester, school: school);

      expect(find.text('Oxford'), findsOneWidget);
      expect(find.text('Noida'), findsOneWidget);

      var editStudentTextFieldList = find.byType(TextFormField);

      await tester.enterText(editStudentTextFieldList.first, '');

      await tester.tap(find.text('Update'));
      await tester.pump();
      expect(find.text('School name is required!!'), findsOneWidget);

      await tester.enterText(editStudentTextFieldList.first, 'Amar');
      await tester.enterText(editStudentTextFieldList.last, 'Washington');
      await tester.pump();

      expect(find.text('Amar'), findsOneWidget);
    });
  });
}
