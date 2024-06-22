

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/ui/schools/schools.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';

import '../../mock_data/school/mock_school_repo.dart';
import 'school_widget_test.mocks.dart';


@GenerateMocks([SchoolRepository])
void main() async {

  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('home widget testing', () {

    late MockSchoolRepository mockSchoolRepo;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      Environment().configure();
      DeviceConfiguration.initiate();
      await Firebase.initializeApp();
      mockSchoolRepo = MockSchoolRepository();
    });

    // tearDown(() {
    //   schoolBloc.close();
    // });

    testWidgets('Testing Existing school flow', (tester) async {


      await tester.pumpWidget(MyApp(schoolRepository: mockSchoolRepo));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.school), findsWidgets);

      expect(find.text('Hello John Carter'), findsOne);

      var school = find.byKey(Key('school'));

      await tester.tap(school);

      when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
        return Future.value(<SchoolModel>[
              SchoolModel('Oxford', 'India', 'Noida', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634),
              SchoolModel('Kennedy', 'India', 'Noida', '52a29100b99c1023a3674150b7aa5f7b', 1718168534634),
              SchoolModel('Delhi', 'India', 'Noida', '52a29100b99c1023a3674150b7ah5f7b', 1718168534634),
              SchoolModel('Cambridge', 'India', 'Noida', '52a29100b99c1023a3674150b7a35f7b', 1718168534634),
              SchoolModel('Infrasonic', 'India', 'Noida', '52a29100b99c1023a3674150b7a75f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b99c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b92c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b3c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100699c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b69c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b97c1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Model school', 'India', 'Noida', '52a29100b99h1023a3674150b7a15f7b', 1718168534634),
              SchoolModel('Sanfransico', 'India', 'Noida', '52a29100b99c7023a3674150b7a15f7b', 1718168534634),
        ]);
      });

      await tester.pumpAndSettle(Duration(seconds: 1));

      var welcomePopup = find.byIcon(Icons.thumb_up);

      await tester.tap(welcomePopup);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(ListTile), findsAtLeast(2));

      /// Offset 0 represents x axis and 5000 represents scroll value, negative value represents up wards scroll and positive values represents downward scroll.
      /// 1000 is scroll velocity.
      await tester.fling(find.byType(ListView), const Offset(0, -5000), 10000);
      await tester.pumpAndSettle();

      expect(find.text('Sanfransico'), findsOneWidget);

      await tester.fling(find.byType(ListView), const Offset(0, 100), 10000);
      await tester.pumpAndSettle();

      /// loading students
      when(mockSchoolRepo.fetchStudents('52a29100b99c1023a3674150b7ab5f7b')).thenAnswer((value) => Future.value(<StudentModel>[StudentModel('1234', '52a29100b99c1023a3674150b7ab5f7b', 'Krishna', 'Noida', '7th Standard', 1718168534634)]));
      when(mockSchoolRepo.fetchSchoolDetails('52a29100b99c1023a3674150b7ab5f7b')).thenAnswer((value) => Future.value(null));

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Add More details'), findsOneWidget);
      
      expect(find.text('Create Student'), findsOneWidget);

      expect(find.text('Krishna'), findsOneWidget);

      when(mockSchoolRepo.fetchStudent('1234', '52a29100b99c1023a3674150b7ab5f7b')).thenAnswer((value) => Future.value(StudentModel('1234', '52a29100b99c1023a3674150b7ab5f7b', 'Krishna', 'Noida', '7th Standard', 1718168534634)));

      var student = find.byType(ListTile);

      await tester.tap(student.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Delete Student'), findsOneWidget);

    });
  });
}