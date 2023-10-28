import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final AppLifecycleListener _lifeCycleListener;

  @override
  void initState() {
    _lifeCycleListener = AppLifecycleListener(
        onStateChange: _onLifeCycleChanged,
        onDetach: _onDetach,
        onPause: _onPause,
        onExitRequested: _onExit
    );
    super.initState();
  }

  @override
  void dispose() {
    _lifeCycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<(String, ScreenType, {String? des})> screenTypes = [
      ('Dashboard', ScreenType.dashboard, des : 'It contains NestedRouting along with Max widgets convered'),
      ('Schools child routing', ScreenType.fullscreenChildRouting, des : 'This describes the routing'),
      ('Automatci Keep alive', ScreenType.automaticKeepAlive, des : 'This makes the screen alive if we navigated to another tab as well'),
      ('Localization', ScreenType.localizationWithCalendar, des : 'Localization and Internalization was implemented in this'),
      ('Upi payments', ScreenType.upiPayments, des : 'Make the upi payments'),
      ('Isolates', ScreenType.isolates, des : 'To make the app light weight'),
    ];

    var userName = 'Krishna';
    var lastName = 'yedlapalli';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helloWorld(lastName, userName)),
      ),
      body: GridView.builder(
          itemCount: screenTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 2),
          itemBuilder: (_, index) => Card(
                child: InkWell(
                  onTap: () => navigateToDashboard(screenTypes.elementAt(index).$2),
                  child: Container(
                       padding: const EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        // gradient:
                        // LinearGradient(colors: [
                        //   Color(0xFF4B72EF),
                        //   Color(0xFF00CCFF),
                        // ],
                        // begin: Alignment.bottomLeft ?? FractionalOffset(-1, 1.0),
                        // end: Alignment.topRight ?? FractionalOffset(1, -1),
                        // stops: [0.4, 0.7],
                        // tileMode: TileMode.repeated,
                        // // tileMode: TileMode.clamp
                        // )

                       // RadialGradient(colors: [
                       //     Color(0xFF4B72EF),
                       //     Color(0xFF00CCFF),
                       // ],
                       // radius: 0.7,
                       // focal: Alignment(0.7, 0.7),
                       // stops: [0.2, .7]
                       // )
                      ),
                      child: Wrap(
                        children: [
                          RichText(
                            text: TextSpan(text: 'Title : ',
                                style:  Theme.of(context).textTheme.labelLarge?.apply(color: Colors.white, fontWeightDelta: 100),
                                children: [TextSpan(text: screenTypes.elementAt(index).$1, style: Theme.of(context).textTheme.bodyLarge?.apply(color: Colors.cyanAccent))]),
                          ),
                         RichText(    text: TextSpan(text: 'Des : ',
                             style:  Theme.of(context).textTheme.labelLarge?.apply(color: Colors.white, fontWeightDelta: 100),
                             children: [TextSpan(text: screenTypes.elementAt(index).des ?? '', style: Theme.of(context).textTheme.bodyLarge?.apply(color: Colors.black))]),)
                        ],
                      )),
                ),
              )),
    );
  }

  navigateToDashboard(ScreenType type) {
    switch (type) {
      case ScreenType.dashboard:
        context.go('/dashboard/cardLayouts');
        break;
      case ScreenType.fullscreenChildRouting:
        context.go('/schools');
        break;
      case ScreenType.automaticKeepAlive:
        context.go('/home/keepalive');
        break;
      case ScreenType.localizationWithCalendar:
        context.go('/home/localization');
        break;
      case ScreenType.upiPayments:
        context.go('/home/upipayments');
        break;
      case ScreenType.isolates:
        context.go('/home/isolates');
        break;    }
  }

  _onDetach() => print('on Detach');

  _onPause() => print('on Pause');

  void _onLifeCycleChanged(AppLifecycleState state) {
    switch(state){
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
