import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/bloc/daily_status_tracker/daily_status_tracker_bloc.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/provider/gemini_provider.dart';
import 'package:sample_latest/services/db/db_configuration.dart';
import 'package:sample_latest/services/repository/daily_tracker_repository.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/latest_3.0.dart';
import 'package:sample_latest/provider/common_provider.dart';
import 'package:sample_latest/core/routing.dart';
import 'package:sample_latest/core/theme.dart';
import 'package:sample_latest/ui/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:sample_latest/adsense_web_stub.dart'
if (dart.library.html) 'package:sample_latest/adsense_web.dart'
as web;

import 'core/environment/environment.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 if(kIsWeb) web.executeWebDependencies();

  // if(Platform.isIOS || Platform.isAndroid) Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  /// For handling rendering/painting/widget building error's
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

 /// Listen to the method channel kind of errors
  PlatformDispatcher.instance.onError = (error, stack) {
    print(error);
    return true;
  };

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: PushNotificationService.currentPlatform,
  );
  if(!kIsWeb) FirebaseDatabase.instance.setPersistenceEnabled(true);

  DbConfigurationsByDev().loadSavedData();
  Dart3Features('krishna', 'yedlapalli');
  DeviceConfiguration.initiate();
  ConnectivityHandler().initialize();
  Environment().configure();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  final SchoolRepository? schoolRepository;

   MyApp({super.key, this.schoolRepository});

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
  void didChangeLocales(List<Locale>? locales) {
    final currentLocale = locales?.first;
    navigatorKey.currentContext?.read<CommonProvider>().onChangeOfLanguage(currentLocale);
    super.didChangeLocales(locales);
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
    var systemLocale = View.of(context).platformDispatcher.locale;

    ThemeMode mode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    systemLocale = AppLocalizations.supportedLocales.firstWhere(
            (existingLocale) =>
            systemLocale.languageCode == existingLocale.languageCode,
        orElse: () => AppLocalizations.supportedLocales.first);

    return MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (context) => CommonProvider(mode, systemLocale)),
        ChangeNotifierProvider(create: (context) => GeminiChatProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => SchoolBloc(widget.schoolRepository ?? SchoolRepository()),),
          BlocProvider(create: (BuildContext context) => DailyTrackerStatusBloc(DailyTrackerRepository()),)
        ],
       child : Builder(
         builder: (context) {
           return OrientationBuilder(
             builder: (context, orientation) {
               DeviceConfiguration.updateDeviceResolutionAndOrientation(MediaQuery.of(context).size, orientation);
               return GlobalLoaderOverlay(
                 child: MaterialApp.router(
                   debugShowCheckedModeBanner: false,
                   title: 'Flutter End to End',
                   localeResolutionCallback: (locale, locales) {
                     // if(locale?.languageCode == 'es') {
                     //   var englishLocale = locales.firstWhere((element) => element.languageCode == 'en');
                     //   context.read<CommonProvider>().onChangeOfLanguage(englishLocale, ignoreNotify: true);
                     //   return englishLocale;
                     // }
                     return locale;
                   },
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
                       textScaler: TextScaler.linear(data.textScaleFactor),
                     ),
                         child: child ?? Container());
                   },
                   theme: CustomTheme.lightThemeData(context),
                   darkTheme: CustomTheme.darkThemeData(),
                   themeMode: context.watch<CommonProvider>().themeModeType,
                   routerConfig: Routing.router,
                 ),
               );
             }
           );
         }
       ),
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
