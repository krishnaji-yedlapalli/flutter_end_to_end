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
  @override
  Widget build(BuildContext context) {
    List<(String, ScreenType, {String? des})> screenTypes = [
      ('Dashboard', ScreenType.dashboard, des : 'It contains NestedRouting along with Max widgets convered'),
      ('Schools child routing', ScreenType.fullscreenChildRouting, des : 'This describes the routing'),
      ('Automatci Keep alive', ScreenType.automaticKeepAlive, des : 'This makes the screen alive if we navigated to another tab as well'),
      ('Localization', ScreenType.localizationWithCalendar, des : 'Localization and Internalization was implemented in this'),
    ];

    var userName = 'Krishna';
    var lastName = 'yedlapalli';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helloWorld(lastName, userName)),
      ),
      body: GridView.builder(
          itemCount: screenTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
          itemBuilder: (_, index) => Card(
                child: InkWell(
                  onTap: () => navigateToDashboard(screenTypes.elementAt(index).$2),
                  child: Container(
                       padding: const EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        gradient:
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

                       RadialGradient(colors: [
                           Color(0xFF4B72EF),
                           Color(0xFF00CCFF),
                       ],
                       radius: 0.7,
                       focal: Alignment(0.7, 0.7),
                       stops: [0.2, .7]
                       )
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
    }
  }
}
