
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/core/environment/environment.dart';
import 'package:sample_latest/provider/common_provider.dart';
import 'package:sample_latest/features/schools/student.dart';
import 'package:sample_latest/utils/device_configurations.dart';

import '../../mock_data/configuration_data.dart';
import '../../mock_data/school/school_mock_data.dart';
import 'create_edit_school_test.mocks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSchoolRepository mockSchoolRepo;

  setUpAll((){
    Environment().configure();
    DeviceConfiguration.initiate();
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
                          CommonProvider(ThemeMode.dark, Locale('en')),
                      child: BlocProvider(
                          key: UniqueKey(),
                          create: (context) => schoolBloc,
                          child: Builder(builder: (context) {
                                return const Student(studentId: '123', schoolId: '123');
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

  group('Testing Student Details', () {


    testWidgets('Student Details', (tester) async {

      when(mockSchoolRepo.fetchStudent(any, any)).thenAnswer((value) => Future.value(SchoolMockData.students.first));

      await pumpSchoolWidgetWithAllDependencies(tester,  SchoolBloc(mockSchoolRepo), TestConfigurationData.screenSizes.first);
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.text('Student Details :'), findsOneWidget);

      expect(find.text('Delete Student'), findsOneWidget);

    });
  });

}