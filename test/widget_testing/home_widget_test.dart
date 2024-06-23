

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_latest/environment/environment.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/ui/home_screen.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';

import '../mock_data/configuration_data.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Environment().configure();
    DeviceConfiguration.initiate();
    await Firebase.initializeApp();
  });

    testWidgets('test home', (tester) async {

      for(Size size in TestConfigurationData.screenSizes) {
        await tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: size),
            child: MyApp(key: UniqueKey())));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Hello John Carter'), findsOne);

        var gridView = find.byType(GridView);
        for(var screenType in ScreenType.values){
          var item = find.byKey(Key(screenType.name));
          if(item.evaluate().isEmpty){
            await tester.fling(gridView, Offset(0, -(size.height)), 1000);
            // await tester.drag(gridView, Offset(0, -(size.height))); /// we can use drag also but fling scroll is fast and drag scroll is smooth like interaction
          }
          expect(find.byKey(Key(screenType.name)), findsOneWidget);
        }
      }
    });
}