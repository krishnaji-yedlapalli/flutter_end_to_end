

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:firebase_core_platform_interface/src/pigeon/mocks.dart';
import '../../unit_testing/school_bloc_test.mocks.dart';

@GenerateMocks([SchoolRepo])

void main() async {

  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('Creating and editing a school', (){

    late MockMockSchoolRepo mockSchoolRepo;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      Environment().configure();
      DeviceConfiguration.initiate();
      await Firebase.initializeApp();
      mockSchoolRepo = MockMockSchoolRepo();
    });

    testWidgets('Creating and editing a school', (tester) async {

      await tester.pumpWidget(MyApp(schoolRepository: mockSchoolRepo));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.school), findsWidgets);

      expect(find.text('Hello John Carter'), findsOne);

      var school = find.byKey(Key('school'));

      await tester.tap(school);

      when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
        return Future.value(<SchoolModel>[]);
      }
        );

      await tester.pumpAndSettle(Duration(seconds: 1));

      var welcomePopup = find.byIcon(Icons.thumb_up);

      await tester.tap(welcomePopup);
      await tester.pumpAndSettle();

      expect(find.text('No Schools Found, Create a new School'),  findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Create School'), findsAtLeast(2));

      /// checking validation
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

      when(mockSchoolRepo.createOrEditSchool(any)).thenAnswer((value) => Future.value(SchoolModel('Kennedy', 'India', 'Hyderabad', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)));

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      var createdSchool = find.byType(ListTile);
      expect(createdSchool, findsOneWidget);

      expect(find.text('Kennedy'), findsOneWidget);

      /// Edit created school

      var edit = find.descendant(of: createdSchool, matching: find.byIcon(Icons.edit));
      await tester.tap(edit);
      await tester.pumpAndSettle();

      var editTextFieldList = find.byType(TextFormField);

      await tester.enterText(editTextFieldList.first, 'Oxford');
      await tester.enterText(editTextFieldList.last, 'San Francisco');

      when(mockSchoolRepo.createOrEditSchool(any)).thenAnswer((value) => Future.value(SchoolModel('Oxford', 'USA', 'San Francisco', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)));
      await tester.tap(find.text('Update'));
      await tester.pump();

      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}