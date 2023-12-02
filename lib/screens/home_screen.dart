import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/cards_mixin.dart';
import 'package:sample_latest/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CardWidgetsMixin {
  late final AppLifecycleListener _lifeCycleListener;

  @override
  void initState() {
    _lifeCycleListener = AppLifecycleListener(
        onStateChange: _onLifeCycleChanged,
        onDetach: _onDetach,
        onPause: _onPause,
        onExitRequested: _onExit);
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
        'Schools child routing',
        ScreenType.fullscreenChildRouting,
        Icons.school,
        des: 'This describes the routing'
      ),
      (
        'Automatci Keep alive',
        ScreenType.automaticKeepAlive,
        Icons.tab,
        des:
            'This makes the screen alive if we navigated to another tab as well'
      ),
      (
        'Localization',
        ScreenType.localizationWithCalendar,
        Icons.language,
        des: 'Localization and Internalization was implemented in this'
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
    ];

    var userName = 'Krishna';
    var lastName = 'yedlapalli';

    return Scaffold(
      appBar: CustomAppBar(
        title:
            Text(AppLocalizations.of(context)!.helloWorld(userName, lastName)),
        appBar: AppBar(),
      ),
      body: GridView.builder(
          itemCount: screenTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 6),
          itemBuilder: (_, index) {
            var screenDetails = screenTypes.elementAt(index);
            return buildHomeCardView(
                title: screenDetails.$1,
                des: screenDetails.des ?? '',
                icon: screenDetails.$3,
                callback: () =>
                    navigateToDashboard(screenTypes.elementAt(index).$2));
          }),
    );
  }

  navigateToDashboard(ScreenType type) {
    String path = switch(type) {
       ScreenType.dashboard =>  DeviceConfiguration.isMobileResolution ? '/dashboard' : '/dashboard/materialComponents',
       ScreenType.fullscreenChildRouting => '/schools',
       ScreenType.automaticKeepAlive => '/home/keepalive',
       ScreenType.localizationWithCalendar => '/home/localization',
       ScreenType.upiPayments => '/home/upipayments',
       ScreenType.isolates => '/home/isolates',
       ScreenType.shortcuts => '/home/actionShortcuts',
       ScreenType.plugins => '/home/plugins',
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
      // TODO: Handle this case.
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
}
