

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';

class MockSchoolBloc extends MockCubit<SchoolState> implements SchoolBloc {}

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('home widget testing', () {

    late MockSchoolBloc schoolBloc;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      Environment().configure();
      DeviceConfiguration.initiate();
      await Firebase.initializeApp();
      schoolBloc = MockSchoolBloc();
    });

    tearDown(() {
      schoolBloc.close();
    });

    testWidgets('test home', (tester) async {

      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.school), findsWidgets);

      expect(find.text('Hello John Carter'), findsOne);

      var school = find.byKey(Key('school'));

      await tester.tap(school);

      await tester.pumpAndSettle(Duration(seconds: 1));

      // when(()=> schoolBloc.state).thenReturn(SchoolInfoInitial())

      var welcomePopup = find.byIcon(Icons.thumb_up);

      await tester.tap(welcomePopup);

      await tester.pumpAndSettle(const Duration(seconds: 1));

    });
  });
}