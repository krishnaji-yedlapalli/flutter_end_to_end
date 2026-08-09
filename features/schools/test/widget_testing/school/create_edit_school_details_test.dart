import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/environment/environment.dart';
import 'package:app_core/shared/presentation/provider/common_provider.dart';
import 'package:schools/domain/entities/entities.dart';
import 'package:schools/domain/use_cases/use_cases.dart';
import 'package:schools/presentation/cubit/school_details_bloc/school_details_bloc.dart';
import 'package:schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:schools/presentation/screens/school_details/school_details.dart';
import 'package:schools/shared/models/school_view_model.dart';

import '../../mock_data/configuration_data.dart';
import '../../mock_data/school/school_mock_data.dart';

class MockSchoolDetailsUseCase extends Mock implements SchoolDetailsUseCase {}

class MockSchoolDetailsModifyUseCase extends Mock
    implements SchoolDetailsModifyUseCase {}

class MockStudentsUseCase extends Mock implements StudentsUseCase {}

class MockStudentUseCase extends Mock implements StudentUseCase {}

class MockStudentModifyUseCase extends Mock implements StudentModifyUseCase {}

class MockDeleteStudentUseCase extends Mock implements DeleteStudentUseCase {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

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
  });

  setUp(() {
    mockSchoolDetailsUseCase = MockSchoolDetailsUseCase();
    mockSchoolDetailsModifyUseCase = MockSchoolDetailsModifyUseCase();
    mockStudentsUseCase = MockStudentsUseCase();
    mockStudentUseCase = MockStudentUseCase();
    mockStudentModifyUseCase = MockStudentModifyUseCase();
    mockDeleteStudentUseCase = MockDeleteStudentUseCase();
  });

  Future<void> pumpSchoolDetails(
      WidgetTester tester, Size size, SchoolViewModel? school) async {
    final studentsBloc = StudentsBloc(mockStudentsUseCase,
        mockStudentModifyUseCase, mockDeleteStudentUseCase, mockStudentUseCase);
    final schoolDetailsBloc = SchoolDetailsBloc(
        mockSchoolDetailsUseCase, mockSchoolDetailsModifyUseCase);

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
                    BlocProvider.value(value: schoolDetailsBloc),
                    BlocProvider.value(value: studentsBloc),
                  ],
                  child: SchoolDetails('123', school),
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

  group('School details widget testing', () {
    testWidgets('Testing with empty students', (tester) async {
      when(() => mockSchoolDetailsUseCase.call('123'))
          .thenAnswer((_) async => const Left(null));
      when(() => mockStudentsUseCase.call('123'))
          .thenAnswer((_) async => const Left(<StudentEntity>[]));

      final school = SchoolMockData.schoolViewModels.first;
      await pumpSchoolDetails(
          tester, TestConfigurationData.screenSizes.first, school);
      await tester.pump();

      expect(find.text('No Students to display, Create a New student'),
          findsOneWidget);
    });

    testWidgets('Testing with Add more school details', (tester) async {
      when(() => mockSchoolDetailsUseCase.call('123'))
          .thenAnswer((_) async => const Left(null));
      when(() => mockStudentsUseCase.call('123'))
          .thenAnswer((_) async => const Left(<StudentEntity>[]));

      final school = SchoolMockData.schoolViewModels.first;
      await pumpSchoolDetails(
          tester, TestConfigurationData.screenSizes.first, school);
      await tester.pump();

      expect(find.text('Add More details'), findsOneWidget);
      expect(find.text('Create Student'), findsOneWidget);
    });

    testWidgets('Testing with existing school details', (tester) async {
      when(() => mockSchoolDetailsUseCase.call('123'))
          .thenAnswer((_) async => Left(SchoolMockData.schoolDetailsEntity));
      when(() => mockStudentsUseCase.call('123'))
          .thenAnswer((_) async => const Left(<StudentEntity>[]));

      final school = SchoolMockData.schoolViewModels.first;
      await pumpSchoolDetails(
          tester, TestConfigurationData.screenSizes.first, school);
      await tester.pump();

      expect(find.text('Add More details'), findsNothing);
      expect(find.text('1200'), findsOneWidget);
      expect(find.text('Hostel Availability :'), findsOneWidget);
    });

    testWidgets('Testing with existing students', (tester) async {
      when(() => mockSchoolDetailsUseCase.call('123'))
          .thenAnswer((_) async => Left(SchoolMockData.schoolDetailsEntity));
      when(() => mockStudentsUseCase.call('123'))
          .thenAnswer((_) async => Left(SchoolMockData.studentEntities));

      final school = SchoolMockData.schoolViewModels.first;
      await pumpSchoolDetails(
          tester, TestConfigurationData.screenSizes.first, school);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Test Different device Resolutions', (tester) async {
      for (var size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);
        DeviceConfiguration.updateDeviceResolutionAndOrientation(
            size, Orientation.portrait);

        when(() => mockSchoolDetailsUseCase.call('123'))
            .thenAnswer((_) async => Left(SchoolMockData.schoolDetailsEntity));
        when(() => mockStudentsUseCase.call('123'))
            .thenAnswer((_) async => Left(SchoolMockData.studentEntities));

        final school = SchoolMockData.schoolViewModels.first;
        await pumpSchoolDetails(tester, size, school);
        await tester.pumpAndSettle();
      }
    });
  });
}
