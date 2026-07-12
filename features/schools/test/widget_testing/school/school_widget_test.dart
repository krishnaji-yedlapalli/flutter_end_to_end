import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sample_latest/core/data/db/offline_handler.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/environment/environment.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/shared/presentation/provider/common_provider.dart';
import 'package:schools/domain/entities/entities.dart';
import 'package:schools/domain/use_cases/use_cases.dart';
import 'package:schools/presentation/cubit/school_details_bloc/school_details_bloc.dart';
import 'package:schools/presentation/cubit/schools_cubit/schools_cubit.dart';
import 'package:schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:schools/presentation/pages/schools/schools_page.dart';
import 'package:schools/presentation/ui_mappers/schools_ui_mapper.dart';

import '../../mock_data/configuration_data.dart';
import '../../mock_data/school/school_mock_data.dart';

class MockSchoolsUseCase extends Mock implements SchoolsUseCase {}

class MockSchoolModifyUseCase extends Mock implements SchoolModifyUseCase {}

class MockDeleteSchoolUseCase extends Mock implements DeleteSchoolUseCase {}

class MockSchoolDetailsUseCase extends Mock implements SchoolDetailsUseCase {}

class MockSchoolDetailsModifyUseCase extends Mock
    implements SchoolDetailsModifyUseCase {}

class MockStudentsUseCase extends Mock implements StudentsUseCase {}

class MockStudentUseCase extends Mock implements StudentUseCase {}

class MockStudentModifyUseCase extends Mock implements StudentModifyUseCase {}

class MockDeleteStudentUseCase extends Mock implements DeleteStudentUseCase {}

class FakeOfflineHandler extends Fake implements OfflineHandler {
  @override
  final queueItemsCount = BehaviorSubject<int>.seeded(0);

  @override
  final dumpingOfflineDataStatus =
      BehaviorSubject<OfflineDumpingStatus>.seeded(null);

  @override
  Future<bool> syncData() async => false;

  @override
  Future<void> eraseAllDatabaseData() async {}

  @override
  Future<bool> dumpOfflineData() async => false;
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('Schools page widget testing', () {
    late MockSchoolsUseCase mockSchoolsUseCase;
    late MockSchoolModifyUseCase mockSchoolModifyUseCase;
    late MockDeleteSchoolUseCase mockDeleteSchoolUseCase;
    late MockSchoolDetailsUseCase mockSchoolDetailsUseCase;
    late MockSchoolDetailsModifyUseCase mockSchoolDetailsModifyUseCase;
    late MockStudentsUseCase mockStudentsUseCase;
    late MockStudentUseCase mockStudentUseCase;
    late MockStudentModifyUseCase mockStudentModifyUseCase;
    late MockDeleteStudentUseCase mockDeleteStudentUseCase;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      Environment().configure();
      DeviceConfiguration.initiate();
      await Firebase.initializeApp();

      // Register a fake OfflineHandler so SchoolsOfflineActions can resolve it
      if (!GetIt.instance.isRegistered<OfflineHandler>()) {
        GetIt.instance.registerSingleton<OfflineHandler>(FakeOfflineHandler());
      }
    });

    tearDownAll(() {
      if (GetIt.instance.isRegistered<OfflineHandler>()) {
        GetIt.instance.unregister<OfflineHandler>();
      }
    });

    setUp(() {
      mockSchoolsUseCase = MockSchoolsUseCase();
      mockSchoolModifyUseCase = MockSchoolModifyUseCase();
      mockDeleteSchoolUseCase = MockDeleteSchoolUseCase();
      mockSchoolDetailsUseCase = MockSchoolDetailsUseCase();
      mockSchoolDetailsModifyUseCase = MockSchoolDetailsModifyUseCase();
      mockStudentsUseCase = MockStudentsUseCase();
      mockStudentUseCase = MockStudentUseCase();
      mockStudentModifyUseCase = MockStudentModifyUseCase();
      mockDeleteStudentUseCase = MockDeleteStudentUseCase();
    });

    Future<void> pumpSchoolsPage(
        WidgetTester tester, SchoolsCubit schoolsCubit, Size size) async {
      final schoolDetailsBloc = SchoolDetailsBloc(
        mockSchoolDetailsUseCase,
        mockSchoolDetailsModifyUseCase,
      );
      final studentsBloc = StudentsBloc(
          mockStudentsUseCase,
          mockStudentModifyUseCase,
          mockDeleteStudentUseCase,
          mockStudentUseCase);

      final goRouter = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => MediaQuery(
              key: UniqueKey(),
              data: MediaQueryData(size: size),
              child: OrientationBuilder(builder: (context, orientation) {
                DeviceConfiguration.updateDeviceResolutionAndOrientation(
                    MediaQuery.of(context).size, orientation);
                return ChangeNotifierProvider(
                  create: (_) =>
                      CommonProvider(ThemeMode.dark, const Locale('en')),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: schoolsCubit),
                      BlocProvider.value(value: schoolDetailsBloc),
                      BlocProvider.value(value: studentsBloc),
                    ],
                    child: const FeatureDiscovery.withProvider(
                      persistenceProvider: NoPersistenceProvider(),
                      child: SchoolsPage(),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(
        key: UniqueKey(),
        routerConfig: goRouter,
        localizationsDelegates: TestConfigurationData.localizationDelegate,
        supportedLocales: TestConfigurationData.supportedLocales,
      ));
    }

    SchoolsCubit buildCubit() => SchoolsCubit(
          schoolsUseCase: mockSchoolsUseCase,
          schoolModifyUseCase: mockSchoolModifyUseCase,
          deleteSchoolUsecase: mockDeleteSchoolUseCase,
          uiMapper: SchoolsUiMapperImp(),
        );

    testWidgets('Testing with No Schools', (tester) async {
      when(() => mockSchoolsUseCase.call())
          .thenAnswer((_) async => const Left(<SchoolEntity>[]));

      await pumpSchoolsPage(
          tester, buildCubit(), TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle();

      expect(
          find.text('No Schools Found, Create a new School'), findsOneWidget);
    });

    testWidgets('Test Existing school flow', (tester) async {
      when(() => mockSchoolsUseCase.call())
          .thenAnswer((_) async => Left(SchoolMockData.schoolEntities));

      await pumpSchoolsPage(
          tester, buildCubit(), TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle();

      // Dismiss welcome dialog if present
      final thumbUp = find.byIcon(Icons.thumb_up);
      if (thumbUp.evaluate().isNotEmpty) {
        await tester.tap(thumbUp);
        await tester.pumpAndSettle();
      }

      expect(find.byType(ListTile), findsAtLeast(2));

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

        SchoolScreenFeatureDiscovery().isCompleted = true;

        when(() => mockSchoolsUseCase.call())
            .thenAnswer((_) async => Left(SchoolMockData.schoolEntities));

        await pumpSchoolsPage(tester, buildCubit(), size);
        await tester.pumpAndSettle();

        // Dismiss welcome dialog if present
        final thumbUp = find.byIcon(Icons.thumb_up);
        if (thumbUp.evaluate().isNotEmpty) {
          await tester.tap(thumbUp);
          await tester.pumpAndSettle();
        }

        await tester.fling(
            find.byType(ListView), const Offset(0, -8000), 10000);
        await tester.pumpAndSettle();

        expect(find.text('Sanfransico'), findsOneWidget);

        await tester.fling(find.byType(ListView), const Offset(0, 100), 10000);
        await tester.pumpAndSettle();
      }
    });
  });
}
