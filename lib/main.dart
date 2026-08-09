import 'dart:io';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:app_core/core/data/db/offline_injection_module.dart';
import 'package:app_core/core/data/network/network_injection_module.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/firebase/firebase_initializer.dart';
import 'package:app_core/core/firebase/services/firebase_crashlytics_service.dart';
import 'package:app_core/core/kiosk/kiosk_gesture_wrapper.dart';
import 'package:app_core/core/kiosk/kiosk_injection_module.dart';
import 'package:app_core/core/kiosk/kiosk_service.dart';
import 'package:sample_latest/core/routing/routing.dart';
import 'package:app_core/core/routing/routing_exports.dart';
import 'package:app_core/core/theme/theme.dart';
import 'package:app_core/core/utils/connectivity_handler.dart';
import 'package:app_core/l10n/app_localizations.dart';

import 'package:app_core/core/device/config/cached_device_manager.dart';
import 'package:app_core/core/environment/environment.dart';
import 'package:app_core/core/firebase/config/remote_config_scope.dart';
import 'package:app_core/core/platform/platform.dart' as platform;
import 'package:app_core/core/splash/splash_screen.dart';
import 'package:app_core/shared/presentation/provider/common_provider.dart';

import 'core/environment/flavor_configurations.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }

Future<void> _initializeApp() async {
  if (kIsWeb) platform.executeWebDependencies();

  // if(Platform.isIOS || Platform.isAndroid) Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  /// For handling rendering/painting/widget building error's
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (GetIt.I.isRegistered<FirebaseCrashlyticsService>()) {
      GetIt.I<FirebaseCrashlyticsService>().recordError(
        details.exception,
        details.stack,
        reason: details.exceptionAsString(),
        fatal: kReleaseMode,
      );
    }
    if (kReleaseMode) exit(1);
  };

  /// Listen to the method channel kind of errors
  PlatformDispatcher.instance.onError = (error, stack) {
    if (GetIt.I.isRegistered<FirebaseCrashlyticsService>()) {
      GetIt.I<FirebaseCrashlyticsService>()
          .recordError(error, stack, fatal: true);
    }
    return true;
  };

  if (kIsWeb || !Platform.isLinux) {
    await FirebaseInitializer.initialize();
    if (!kIsWeb) FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  /// Initialize Offline dependencies
  if (!kIsWeb) {
    await OfflineInjectionModule().registerDependencies();
  }

  DeviceConfiguration.initiate();
  ConnectivityHandler().initialize();
  Environment().registerResolver(resolveFlavorConfig);
  Environment().configure();

  // Register network layer dependencies
  await NetworkInjectionModule.registerDependencies();

  // Register kiosk service dependencies
  if (!kIsWeb && Platform.isLinux) {
    KioskInjectionModule().registerDependencies();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Having two run apps is not a good idea, there will be no smooth transistion between
  /// Spash screen and actual dashboard
  runApp(const SplashScreen());

  await Future.wait([
    _initializeApp(),
    Future.delayed(SplashScreen.totalDuration),
  ]);

  // FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // Enter kiosk mode on Linux platform after the first frame is rendered.
    if (!kIsWeb && Platform.isLinux) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GetIt.instance<IKioskService>().enterKioskMode();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    final currentLocale = locales?.first;
    NavigationKeys.navigatorKey.currentContext
        ?.read<CommonProvider>()
        .onChangeOfLanguage(currentLocale);
    super.didChangeLocales(locales);
  }

  @override
  void didChangePlatformBrightness() {
    var brightness = View.of(context).platformDispatcher.platformBrightness;
    NavigationKeys.navigatorKey.currentContext
        ?.read<CommonProvider>()
        .updateThemeData(
            brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    var systemLocale = View.of(context).platformDispatcher.locale;

    ThemeMode mode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    systemLocale = AppLocalizations.supportedLocales.firstWhere(
        (existingLocale) =>
            systemLocale.languageCode == existingLocale.languageCode,
        orElse: () => AppLocalizations.supportedLocales.first);

    // This remote config scope is to override the remote values in local.
    return RemoteConfigScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => CommonProvider(mode, systemLocale)),
          // ChangeNotifierProvider(create: (context) => GeminiChatProvider()),
        ],
        child: Builder(
          builder: (context) => DeviceConfigurationProvider(
            child: OrientationBuilder(
              builder: (context, orientation) {
                DeviceConfiguration.updateDeviceResolutionAndOrientation(
                    MediaQuery.of(context).size,
                    orientation,
                    MediaQuery.of(context).devicePixelRatio);
                final appContent = GlobalLoaderOverlay(
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
                    builder: (BuildContext context, Widget? child) {
                      var data = MediaQuery.of(context);
                      return MediaQuery(
                          data: data.copyWith(
                            textScaler:
                                TextScaler.linear(data.textScaler.scale(1)),
                          ),
                          child: child ?? Container());
                    },
                    theme: CustomTheme.lightThemeData(context),
                    darkTheme: CustomTheme.darkThemeData(),
                    themeMode: context.watch<CommonProvider>().themeModeType,
                    routerConfig: Routing.router,
                  ),
                );
                // KioskGestureWrapper intercepts touch events for inactivity
                // timer reset, display wake, and exit gesture detection.
                // It is only needed on Linux (kiosk/Raspberry Pi) builds.
                if (!kIsWeb && Platform.isLinux) {
                  return KioskGestureWrapper(
                    kioskService: GetIt.instance<IKioskService>(),
                    child: appContent,
                  );
                }

                return appContent;
              },
            ),
          ),
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
