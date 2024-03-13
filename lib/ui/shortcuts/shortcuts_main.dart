

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_latest/ui/shortcuts/call_back_shortcuts.dart';
import 'package:sample_latest/ui/shortcuts/shortcut_actions.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class ShortcutsTabView extends StatefulWidget {
  const ShortcutsTabView({Key? key}) : super(key: key);

  @override
  State<ShortcutsTabView> createState() => _ShortcutsTabViewState();
}

class _ShortcutsTabViewState extends State<ShortcutsTabView> with SingleTickerProviderStateMixin {

  late TabController tabCtrl;

  @override
  initState() {
    tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: Text('Shortcuts')),
      body: Shortcuts(
        // bindings: <SingleActivator, VoidCallback>{
        //   SingleActivator(LogicalKeyboardKey.arrowLeft) : () {
        //     tabCtrl.animateTo(0);
        //   },
        //   SingleActivator(LogicalKeyboardKey.arrowRight) : () {
        //     tabCtrl.animateTo(1);
        //   }
        // },
        shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowRight) : TabChangeRightIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft) : TabChangeLeftIntent()
        },
        child: Actions(
          actions: <Type, Action>{
            TabChangeRightIntent : TabChangeRightAction(tabCtrl),
            TabChangeLeftIntent : TabChangeLeftAction(tabCtrl),
          },
          child: Column(
              children: [
                TabBar(
                    controller: tabCtrl,
                    isScrollable: true,
                    tabs: [
                  Tab(text: 'Call Back Shortcuts'),
                  Tab(text: 'Action Shortcuts'),
                ]),
                Expanded(
                  child: TabBarView(
                      controller: tabCtrl,
                      children: [
                    const CallBackShortCutsView(),
                    ShortcutActions()
                  ]),
                )
              ],
            ),
        ),
      ),
    );
  }
}

class TabChangeRightIntent extends Intent {
  TabChangeRightIntent();
}

class TabChangeRightAction extends Action<TabChangeRightIntent> {

  TabChangeRightAction(this.tabController);

  final TabController tabController;
  @override
  Object? invoke(covariant TabChangeRightIntent intent) {
    tabController.animateTo(1);
  }
}

class TabChangeLeftIntent extends Intent {
  TabChangeLeftIntent();
}

class TabChangeLeftAction extends Action<TabChangeLeftIntent> {

  TabChangeLeftAction(this.tabController);

  final TabController tabController;
  @override
  Object? invoke(TabChangeLeftIntent intent) {
    tabController.animateTo(0);
  }
}
