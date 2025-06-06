import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_bloc.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/core/presentation/provider/common_provider.dart';
import 'package:sample_latest/features/schools/data/repository/school_repository.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/features/schools/presentation/screens/schools/create_update_school.dart';
import 'package:sample_latest/features/schools/presentation/screens/schools/schools.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import '../../mock_data/configuration_data.dart';

@GenerateMocks([SchoolRepository])
void main() async {

  late SchoolBloc schoolBloc;

  setUp(() {
    DeviceConfiguration.initiate();
  });

  group('Creating and editing a school', () {

    testWidgets('Creating  school', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: CreateSchool())));
      await tester.pumpAndSettle();

      expect(find.text('Create School'), findsAtLeast(1));

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
    });

    testWidgets('Edit existing school', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: CreateSchool(
                  school: SchoolModel('Oxford', 'India', 'Noida',
                      '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)))));
      await tester.pumpAndSettle();

      expect(find.text('Oxford'), findsOneWidget);
      expect(find.text('India'), findsOneWidget);
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

    testWidgets('Testing different Screen resolution', (tester) async {

      for (var size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);
        DeviceConfiguration.updateDeviceResolutionAndOrientation(
            size, Orientation.portrait);

        schoolBloc = SchoolBloc(SchoolRepository());
        schoolBloc.isWelcomeMessageShowed =true;
        SchoolScreenFeatureDiscovery().isCompleted = true;

        final GoRouter goRouter = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => MediaQuery(
                  data: MediaQueryData(size: size),
                  child: ChangeNotifierProvider(
                    create: (context) =>
                        CommonProvider(ThemeMode.dark, const Locale('en')),
                    child: BlocProvider(
                        create: (context) => schoolBloc,
                        child: FeatureDiscovery.withProvider(
                            persistenceProvider: const NoPersistenceProvider(),
                            child: Builder(builder: (context) {
                              return const Schools();
                            }))),
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

        await tester.tap(find.byType(FloatingActionButton));
        // await tester.tap(find.text('Create School'));
        await tester.pumpAndSettle();

        /// checking validation
        await tester.tap(find.text('Create'));
        await tester.pump();

        expect(find.text('School name is required!!'), findsOneWidget);
        expect(find.text('Country is required!!'), findsOneWidget);
        expect(find.text('Location is required!!'), findsOneWidget);

        var editStudentTextFieldList = find.byType(TextFormField);
        await tester.enterText(editStudentTextFieldList.first, 'Amar');
        await tester.enterText(editStudentTextFieldList.last, 'Washington');
        await tester.pump();

        expect(find.text('Amar'), findsOneWidget);
      }
    });
  });
}
