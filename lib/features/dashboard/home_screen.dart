import 'dart:ui';

import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:app_core/core/firebase/config/remote_config_keys.dart';
import 'package:app_core/core/firebase/config/remote_config_scope.dart';
import 'package:app_core/core/utils/connectivity_handler.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
// import 'package:app_update_feature/core/app_update_startup_check.dart';
import 'package:feature_discovery_module/home_feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:push_notifications/push_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/home_screen_items.dart';
import 'widgets/app_version_text.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_grid.dart';
import 'widgets/remote_config_override_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLifecycleListener _lifeCycleListener;

  // GlobalKey offlineBannerKey = GlobalKey();

  @override
  void initState() {
    _lifeCycleListener = AppLifecycleListener(
      onStateChange: _onLifeCycleChanged,
      onDetach: () => print('on Detach'),
      onPause: () => print('on Pause'),
      onExitRequested: _onExit,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Some features are currently on development')));
      _buildMaterialBanner();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        // offlineBannerKey.currentState;
        // if(!ConnectivityHandler().isConnected) _buildNetworkConnectivityStatus();
      });
      showFeatureDiscovery();
    });

    ConnectivityHandler()
        .connectionChangeStatusController
        .stream
        .listen((connected) {
      if (mounted && !connected) {
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

  Future<void> showFeatureDiscovery() async {
    /// This feature will be enabled once app updare issue solved for web.
    // final allow = await AppUpdateStartupCheck.performCheck(context);
    // if (allow)
    HomeScreenFeatureDiscovery().startFeatureDiscovery(context);
  }

  @override
  void dispose() {
    _lifeCycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        RemoteConfigScope.of(context).getString(RemoteConfigKeys.appTitleLabel);
    return Scaffold(
      appBar: HomeAppBar(
        title: title,
        onRemoteConfigTap: () => showRemoteConfigOverrideDialog(context),
        onAppsTap: _launchAppUrl,
        onFeatureTourTap: () => HomeScreenFeatureDiscovery()
            .startFeatureDiscovery(context, forceTour: true),
      ),
      body: HomeGrid(onItemTap: _navigate),
      bottomNavigationBar: const AppVersionText(),
    );
  }

  void _navigate(ScreenType type) => context.go(homeScreenRoutePath(type));

  Future<AppExitResponse> _onExit() async {
    final response = await showDialog<AppExitResponse>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to close app?'),
        content: const Text('All unsaved data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(AppExitResponse.cancel),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(AppExitResponse.exit),
            child: const Text('Exit the App'),
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
        ]),
      ),
      actions: [
        IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          icon: const Icon(Icons.close, color: Colors.white),
        )
      ],
    ));
  }

  void _buildNetworkConnectivityStatus() {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      // key: offlineBannerKey,
      leading: StreamBuilder<int>(
        stream: OfflineHandler().queueItemsCount.stream,
        initialData: 0,
        builder: (context, snapshot) => Badge(
          label: Text('${snapshot.data ?? 0}'),
          child: TextButton(
            onPressed: OfflineHandler().syncData,
            child: const Text('Sync'),
          ),
        ),
      ),
      content: const Align(alignment: Alignment.center, child: Text('Offline')),
      actions: const [
        Text('Retry',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white))
      ],
      contentTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
    ));
  }

  void _launchAppUrl(String val) async {
    final url = val == 'android'
        ? 'https://github.com/krishnaji-yedlapalli/flutter_end_to_end/tree/gh-pages'
        : 'https://testflight.apple.com/join/UulGfVnn';
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      print('error launching $url');
    }
  }

  void _onLifeCycleChanged(AppLifecycleState state) {}
}
