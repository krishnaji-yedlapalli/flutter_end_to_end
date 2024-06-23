

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
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/provider/common_provider.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/ui/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/ui/schools/schools.dart';
import 'package:sample_latest/utils/device_configurations.dart';
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

    // tearDown(() {
    //   schoolBloc.close();
    // });

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
                        CommonProvider(ThemeMode.dark, Locale('en')),
                    child: BlocProvider(
                      key: UniqueKey(),
                        create: (context) => schoolBloc,
                        child: FeatureDiscovery.withProvider(
                            persistenceProvider: NoPersistenceProvider(),
                            child: Builder(builder: (context) {
                              return Schools();
                            }))),
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('hi'),
          Locale('he'),
        ],
      ));
    }

    testWidgets('Testing feature discovery', (tester) async {

      await pumpSchoolWidgetWithAllDependencies(tester, SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);

      bool schoolOverlayDismissed = false;
      for (int i = 0; i < 100; i++) {
        await tester.pump(
            const Duration(milliseconds: 100)); // Pump for a short duration

        // Check if the overlay is dismissed
        if (find.text('Dismiss').evaluate().isNotEmpty) {
          final schoolDismiss = find.text('Dismiss');
          schoolOverlayDismissed = true;
          await tester.tap(schoolDismiss);
        }
        if (schoolOverlayDismissed) {
          break;
        }
      }
      await tester.pumpAndSettle();

      var welcomePopup = find.byIcon(Icons.thumb_up);

      await tester.tap(welcomePopup);
      await tester.pump();
    });

    testWidgets('Testing with No Schools', (tester) async {

      when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
        return Future.value(<SchoolModel>[]);
      });

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle();

      expect(find.text('No Schools Found, Create a new School'),  findsOneWidget);

    });

    testWidgets('Test Existing school flow', (tester) async {

      var schoolBloc = SchoolBloc(mockSchoolRepo);
      schoolBloc.isWelcomeMessageShowed = true;
      when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
        return Future.value(SchoolMockData.schools);
      });

      await pumpSchoolWidgetWithAllDependencies(tester, schoolBloc, TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsAtLeast(2));

      /// Offset 0 represents x axis and 5000 represents scroll value, negative value represents up wards scroll and positive values represents downward scroll.
      /// 1000 is scroll velocity.
      await tester.fling(find.byType(ListView), const Offset(0, -8000), 10000);
      await tester.pumpAndSettle();

      expect(find.text('Sanfransico'), findsOneWidget);

      await tester.fling(find.byType(ListView), const Offset(0, 100), 10000);
      await tester.pumpAndSettle();
    });

    testWidgets('Test Different device Resolutions', (tester) async {

      for (var size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);
        DeviceConfiguration.updateDeviceResolutionAndOrientation(
            size, Orientation.portrait);

        var schoolBloc = SchoolBloc(mockSchoolRepo);
        schoolBloc.isWelcomeMessageShowed =true;
        SchoolScreenFeatureDiscovery().isCompleted = true;

        when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
          return Future.value(SchoolMockData.schools);
        });

        await pumpSchoolWidgetWithAllDependencies(tester, schoolBloc, size);
        await tester.pumpAndSettle();

        await tester.fling(find.byType(ListView), const Offset(0, -8000), 10000);
        await tester.pumpAndSettle();

        expect(find.text('Sanfransico'), findsOneWidget);

        await tester.fling(find.byType(ListView), const Offset(0, 100), 10000);
        await tester.pumpAndSettle();
      }
    });

    });
}