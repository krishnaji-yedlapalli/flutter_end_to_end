import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/feature_discovery_mixin.dart';
import 'package:sample_latest/core/data/db/offline_handler.dart';
import 'package:sample_latest/core/mixins/cards_mixin.dart';
import 'package:sample_latest/features/push_notifcations/push_notification_service.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feature_discovery/home_feature_discovery.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with CardWidgetsMixin, CustomDialogs, FeatureDiscovery {
  late final AppLifecycleListener _lifeCycleListener;

  // GlobalKey offlineBannerKey = GlobalKey();

  @override
  void initState() {
    _lifeCycleListener = AppLifecycleListener(
        onStateChange: _onLifeCycleChanged,
        onDetach: _onDetach,
        onPause: _onPause,
        onExitRequested: _onExit);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if(DeviceConfiguration.isWeb) buildAlertDialog(context, title : '!!! Hey !!!', content : 'Discover how Android and iOS apps utilize Offline, background, and Isolate functionalities. Install now');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Some features are currently on development')));
      _buildMaterialBanner();
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        // offlineBannerKey.currentState;
        // if(!ConnectivityHandler().isConnected) _buildNetworkConnectivityStatus();
      });
      HomeScreenFeatureDiscovery().startFeatureDiscovery(context);
    });

    ConnectivityHandler()
        .connectionChangeStatusController
        .stream
        .listen((bool state) {
      if (mounted && !state) {
        // print('sdf sf  $state');
        // ScaffoldMessenger.maybeOf(context)?.hideCurrentMaterialBanner();
        _buildNetworkConnectivityStatus();
      } else {
        ScaffoldMessenger.maybeOf(context)?.clearMaterialBanners();
      }
    });

    PushNotificationService.initiateTheFirebaseListeners();
    PushNotificationService.initializeLocalPushNotifications();
    super.initState();
  }

  @override
  void dispose() {
    _lifeCycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<(String, ScreenType, IconData, {String? des})> screenTypes = [
      (
        'Dashboard',
        ScreenType.dashboard,
        Icons.dashboard,
        des:
            'It contains Shell Routing along with Material and Cupertino components'
      ),
      (
        'Localization',
        ScreenType.localizationWithCalendar,
        Icons.language,
        des: 'Localization and Internalization was implemented in this'
      ),
      (
        'Routing concept',
        ScreenType.routing,
        Icons.school,
        des: 'This describes the routing'
      ),
      (
        'School Journey with Clean Architecture',
        ScreenType.school,
        Icons.school,
        des: 'This Journey helps the developer to learn to develop the application with Clean architecture by applying solid principles'
      ),
      (
      'School Journey with MVC',
      ScreenType.schoolMvc,
      Icons.school,
      des: 'This Journey helps the developer to develop the small scale application with MVC architecture'
      ),
      (
        'Push Notifications',
        ScreenType.pushNotifications,
        Icons.notifications,
        des: 'Firebase push notifications'
      ),
      (
        'Deep Linking',
        ScreenType.deepLinking,
        Icons.notifications,
        des: 'Test the deeplink in device'
      ),
      (
        'Daily Tracker UI',
        ScreenType.dailyTracker,
        Icons.accessibility_sharp,
        des: 'We can track daily activities'
      ),
      (
        'Gemini Generative AI',
        ScreenType.gemini,
        Icons.chat,
        des: 'Chat with Gemini'
      ),
      (
        'Automatci Keep alive',
        ScreenType.automaticKeepAlive,
        Icons.tab,
        des:
            'This makes the screen alive if we navigated to another tab as well'
      ),
      (
        'Upi payments',
        ScreenType.upiPayments,
        Icons.payment,
        des: 'Make the upi payments, Supports Android only'
      ),
      (
        'Isolates',
        ScreenType.isolates,
        Icons.memory,
        des: 'Currently works in Mobile application only'
      ),
      (
        'Call Back Shortcuts',
        ScreenType.shortcuts,
        Icons.app_shortcut,
        des:
            'Using keyboard shortcuts we can manipulate the options in the screen'
      ),
      (
        'Plugins',
        ScreenType.plugins,
        Icons.power,
        des: 'Here we can access different types of plugins'
      ),
      (
        'scrollTypes',
        ScreenType.scrollTypes,
        Icons.poll,
        des: 'Here we can access different types of plugins'
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(AppLocalizations.of(context)!.greetings('John', "Carter")),
        appBar: AppBar(),
        actions: [
          DeviceConfiguration.isWeb
              ? HomeScreenFeatureDiscovery().aboutAppsDiscovery(onTapOfApps)
              : featureDiscovery(() => HomeScreenFeatureDiscovery()
                  .startFeatureDiscovery(context, forceTour: true))
        ],
      ),
      body: GridView.builder(
          itemCount: screenTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DeviceConfiguration.isMobileResolution
                  ? 2
                  : DeviceConfiguration.isDesktopResolution
                      ? 8
                      : 6),
          itemBuilder: (_, index) {
            var screenDetails = screenTypes.elementAt(index);
            var module = buildHomeCardView(
                key: Key(screenDetails.$2.name),
                title: screenDetails.$1,
                des: screenDetails.des ?? '',
                icon: screenDetails.$3,
                callback: () =>
                    navigateToDashboard(screenTypes.elementAt(index).$2));
            return HomeScreenFeatureDiscovery.features
                    .contains(screenDetails.$2.name)
                ? HomeScreenFeatureDiscovery()
                    .aboutModuleDiscovery(module, screenDetails.$2)
                : module;
          }),
    );
  }

  navigateToDashboard(ScreenType type) {
    String path = switch (type) {
      ScreenType.dashboard => DeviceConfiguration.isMobileResolution
          ? '/home/dashboard'
          : '/home/dashboard/materialComponents',
      ScreenType.school => '/home/schools',
      ScreenType.schoolMvc => '/home/schools',
      ScreenType.automaticKeepAlive => '/home/keepalive',
      ScreenType.localizationWithCalendar => '/home/localization',
      ScreenType.upiPayments => '/home/upipayments',
      ScreenType.isolates => '/home/isolates',
      ScreenType.shortcuts => '/home/actionShortcuts',
      ScreenType.plugins => '/home/plugins',
      ScreenType.scrollTypes => '/home/scrollTypes',
      ScreenType.routing => '/home/route',
      ScreenType.pushNotifications =>
        '/home/push-notifications/remote-notifications',
      ScreenType.deepLinking => '/home/deep-linking',
      ScreenType.gemini => '/home/gemini',
      ScreenType.dailyTracker => '/home/login-page',
    };
    context.go(path);
  }

  _onDetach() => print('on Detach');

  _onPause() => print('on Pause');

  void _onLifeCycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      // TODO: Handle this case.
      case AppLifecycleState.resumed:
      // TODO: Handle this case.
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
      case AppLifecycleState.paused:
      // TODO: Handle thissch case.
    }
  }

  Future<AppExitResponse> _onExit() async {
    final response = await showDialog<AppExitResponse>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to close app?'),
        content: const Text('All unsaved data will be lost.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(AppExitResponse.cancel);
            },
          ),
          TextButton(
            child: const Text('Exist the App'),
            onPressed: () {
              Navigator.of(context).pop(AppExitResponse.exit);
            },
          ),
        ],
      ),
    );

    return response ?? AppExitResponse.exit;
  }

  void _buildMaterialBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: 'Some features are currently under development',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(
              text: ' - Used MaterialBanner to construct this',
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        ])),
        actions: [
          IconButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              icon: const Icon(Icons.close, color: Colors.white))
        ]));
  }

  void _buildNetworkConnectivityStatus() {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      // key: offlineBannerKey,
      leading: StreamBuilder<int>(
        stream: OfflineHandler().queueItemsCount.stream,
        initialData: 0,
        builder: (context, snapshot) {
          var count = 0;
          if (snapshot.hasData) {
            count = snapshot.data ?? 0;
          }
          return Badge(
              label: Text('$count'),
              child: TextButton(
                  onPressed: OfflineHandler().syncData,
                  child: const Text('Sync')));
        },
      ),
      content: const Align(alignment: Alignment.center, child: Text('Offline')),
      actions: [
        const Text('Retry',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white)) ??
            TextButton(
                onPressed: () {},
                child: const Text('Retry',
                    style: TextStyle(fontWeight: FontWeight.w600)))
      ],
      contentTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      // margin: const EdgeInsets.all(0),
    ));
  }

  void onTapOfApps(String val) async {
    String url = val == 'android'
        ? 'https://github.com/krishnaji-yedlapalli/flutter_end_to_end/tree/gh-pages'
        : 'https://testflight.apple.com/join/UulGfVnn';

    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      print('error');
    }
  }
}
