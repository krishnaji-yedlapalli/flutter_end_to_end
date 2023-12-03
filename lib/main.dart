import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/latest_3.0.dart';
import 'package:sample_latest/provider/common_provider.dart';
import 'package:sample_latest/routing.dart';
import 'package:sample_latest/theme.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // if(Platform.isIOS || Platform.isAndroid) Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Dart3Features('krishna', 'yedlapalli');
  DeviceConfiguration.initiate();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    var brightness = View.of(context).platformDispatcher.platformBrightness;
    navigatorKey.currentContext?.read<CommonProvider>().updateThemeData(brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
    super.didChangePlatformBrightness();
  }


  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    ThemeMode mode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (context) => CommonProvider(mode))
      ],
      child: Builder(
        builder: (context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              DeviceConfiguration.updateDeviceResolutionAndOrientation(context, orientation);
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter End to End',
                localeResolutionCallback: (locale, locales) {
                  debugPrint(locale.toString());
                  context.read<CommonProvider>().onChangeOfLanguage(locale, ignoreNotify: true);
                  return locale;
                },
                // localeListResolutionCallback: (locale, locales) {
                //  print(locale);
                //  // return locales;
                // },
                locale: context.watch<CommonProvider>().locale,
                // onGenerateTitle: (context) => DemoLocalizations.of(context).title,
                // backButtonDispatcher: () => ,
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
                /// text scale factor
                builder: (BuildContext context, Widget? child){
                  var data = MediaQuery.of(context);
                  return MediaQuery(data:data.copyWith(
                    textScaleFactor : data.textScaleFactor,
                  ),
                      child: child ?? Container());
                },
                theme: CustomTheme.lightThemeData(context),
                darkTheme: CustomTheme.darkThemeData(),
                themeMode: context.watch<CommonProvider>().themeModeType,
                routerConfig: Routing.router,
              );
            }
          );
        }
      ),
    );
  }
}


// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case 'be.tramckrijte.workmanagerExample.simpleTask':
//         WidgetsFlutterBinding.ensureInitialized();
//         DartPluginRegistrant.ensureInitialized();
//         int i = 0;
//         // while (i < 120) {
//         //   await Future.delayed(Duration(seconds: 2));
//         //   AudioCache audioPlayer = AudioCache(fixedPlayer: AudioPlayer(mode: PlayerMode.MEDIA_PLAYER));
//         //   audioPlayer.play('announcement.mp3');
//         //   i ++;
//         // }
//         // SharedPreferences prefs = await SharedPreferences.getInstance();
//         // await prefs.setInt('getTimeBackground', i+200);
//         // var a = prefs.getInt('getTimeBackground');
//         // print(a);
//         break;
//       case Workmanager.iOSBackgroundTask:
//         print("The iOS background fetch was triggered");
//         // Directory tempDir = await getTemporaryDirectory();
//         // String tempPath = tempDir.path;
//         print(
//             "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): ");
//         break;
//     }
//
//     return Future.value(true);
//   });
// }
