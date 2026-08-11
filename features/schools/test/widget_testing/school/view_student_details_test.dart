import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/environment/environment.dart';
import 'package:ui_kit/presentation/provider/common_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:schools/domain/use_cases/use_cases.dart';
import 'package:schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:schools/presentation/screens/student/student.dart';

import '../../mock_data/configuration_data.dart';
import '../../mock_data/school/school_mock_data.dart';

class MockStudentsUseCase extends Mock implements StudentsUseCase {}

class MockStudentUseCase extends Mock implements StudentUseCase {}

class MockStudentModifyUseCase extends Mock implements StudentModifyUseCase {}

class MockDeleteStudentUseCase extends Mock implements DeleteStudentUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

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
    mockStudentsUseCase = MockStudentsUseCase();
    mockStudentUseCase = MockStudentUseCase();
    mockStudentModifyUseCase = MockStudentModifyUseCase();
    mockDeleteStudentUseCase = MockDeleteStudentUseCase();
  });

  Future<void> pumpStudentWidget(WidgetTester tester, Size size) async {
    final studentsBloc = StudentsBloc(mockStudentsUseCase,
        mockStudentModifyUseCase, mockDeleteStudentUseCase, mockStudentUseCase);

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
                child: BlocProvider.value(
                  value: studentsBloc,
                  child: const Student(studentId: '321', schoolId: '123'),
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

  group('Testing Student Details', () {
    testWidgets('Student Details', (tester) async {
      when(() => mockStudentUseCase.call('321', '123'))
          .thenAnswer((_) async => Left(SchoolMockData.studentEntities.first));

      await pumpStudentWidget(tester, TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Student Details :'), findsOneWidget);
      expect(find.text('Delete Student'), findsOneWidget);
    });
  });
}
