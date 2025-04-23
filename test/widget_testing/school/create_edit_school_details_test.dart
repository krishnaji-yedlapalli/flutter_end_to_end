

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_bloc.dart';
import 'package:sample_latest/core/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/features/schools/data/model/student_model.dart';
import 'package:sample_latest/core/presentation/provider/common_provider.dart';
import 'package:sample_latest/features/schools/data/repository/school_repository.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/features/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/features/schools/presentation/screens/school_details/school_details.dart';
import 'package:sample_latest/features/schools/presentation/screens/schools/schools.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../mock_data/configuration_data.dart';
import '../../mock_data/school/school_mock_data.dart';
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

    Future<void> pumpSchoolWidgetWithAllDependencies(WidgetTester tester, SchoolBloc schoolBloc,  Size size) async {

      final GoRouter goRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => MediaQuery(
                key: UniqueKey(),
                data: MediaQueryData(size: size),
                child: OrientationBuilder(
                    builder : (context, orientation) {
                      DeviceConfiguration.updateDeviceResolutionAndOrientation(MediaQuery.of(context).size, orientation);
                      return ChangeNotifierProvider(
                        create: (context) =>
                            CommonProvider(ThemeMode.dark, const Locale('en')),
                        child: BlocProvider(
                            key: UniqueKey(),
                            create: (context) => schoolBloc,
                            child: Builder(builder: (context) {
                                  return SchoolDetails('123', SchoolMockData.schools.first);
                                })),
                      );
                    }
                )), // Replace with your actual widget
          ),
          // Add other routes as needed
        ],
      );

      await tester.pumpWidget(MaterialApp.router(
        key: UniqueKey(),
        routerConfig: goRouter,
        localizationsDelegates: TestConfigurationData.localizationDelegate,
        supportedLocales: TestConfigurationData.supportedLocales ,
      ));
    }

    testWidgets('Testing with empty students', (tester) async {

      when(mockSchoolRepo.fetchSchoolDetails('123')).thenAnswer((value) {
        return Future.value(null);
      });
      when(mockSchoolRepo.fetchStudents('123')).thenAnswer((value) {
        return Future.value(<StudentModel>[]);
      });

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pump();

      expect(find.text('No Students to display, Create a New student'),  findsOneWidget);

    });

    testWidgets('Testing with Add more school details', (tester) async {

      when(mockSchoolRepo.fetchSchoolDetails('123')).thenAnswer((value) {
        return Future.value(null);
      });

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pump();

      expect(find.text('Add More details'), findsOneWidget);

      expect(find.text('Create Student'), findsOneWidget);
    });

    testWidgets('Testing with existing Add more details', (tester) async {
      when(mockSchoolRepo.fetchSchoolDetails('123')).thenAnswer((value) {
        return Future.value(SchoolMockData.schoolDetails);
      });

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pump();

      expect(find.text('Add More details'), findsNothing);

      expect(find.text('1200'), findsOneWidget);

      expect(find.text('Hostel Availability :'), findsOneWidget);

    });

    testWidgets('Testing with existing students', (tester) async {

      when(mockSchoolRepo.fetchSchoolDetails('123')).thenAnswer((value) {
        return Future.value(SchoolMockData.schoolDetails);
      });

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pump();

      expect(find.text('View Students'), findsOneWidget);

      when(mockSchoolRepo.fetchStudents('123')).thenAnswer((value) {
        return Future.value(SchoolMockData.students);
      });

      await tester.tap(find.text('View Students'));
      await tester.pump();

      expect(find.byType(ListTile), findsWidgets);

      await tester.fling(find.byType(ListView), const Offset(0, -8000), 10000);
      await tester.pumpAndSettle();

      expect(find.text('Ramesh'), findsOneWidget);

    });

    testWidgets('Test Different device Resolutions', (tester) async {

      for (var size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);
        DeviceConfiguration.updateDeviceResolutionAndOrientation(
            size, Orientation.portrait);

        var schoolBloc = SchoolBloc(mockSchoolRepo);

        when(mockSchoolRepo.fetchSchoolDetails('123')).thenAnswer((value) {
          return Future.value(SchoolMockData.schoolDetails);
        });

        await pumpSchoolWidgetWithAllDependencies(tester, schoolBloc, size);
        await tester.pumpAndSettle();

        when(mockSchoolRepo.fetchStudents('123')).thenAnswer((value) {
          return Future.value(SchoolMockData.students);
        });

        await tester.tap(find.text('View Students'));
        await tester.pump();

        await tester.fling(find.byType(ListView), const Offset(0, -8000), 10000);
        await tester.pumpAndSettle();

        expect(find.text('Ramesh'), findsOneWidget);

        await tester.fling(find.byType(ListView), const Offset(0, 100), 10000);
        await tester.pumpAndSettle();
      }
    });

  });
}