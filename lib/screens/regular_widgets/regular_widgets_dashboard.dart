import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegularlyUsedWidgetsDashboard extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  RegularlyUsedWidgetsDashboard(this.navigationShell, {Key? key}) : super(key: key);

  int selectedIndex = 0;
  List<(IconData, String)> navigationRails = [
    (Icons.add_alert, 'Dialogs'),
    (Icons.layers_outlined, 'Cards Layout'),
    (Icons.shortcut, 'Call Back Shortcuts'),
    (Icons.send_time_extension, 'Stepper '),
    (Icons.model_training, 'Physical Model'),
    (Icons.layers_outlined, 'Cards Layout'),
    (Icons.layers_outlined, 'Cards Layout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commonly Used Widgets'),
      ),
      body: Row(
        children: [_buildNavigationRail(context), Expanded(child: navigationShell)],
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
        extended: true,
        onDestinationSelected: (index) {
          selectedIndex = index;
          navigationShell.goBranch(index);
        },
        leading: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
          const Icon(Icons.widgets, color: Colors.blue),
          Text('Widgets', style: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.blue))
        ],),
        destinations: navigationRails
            .map((e) => NavigationRailDestination(
                icon: Icon(
                  e.$1,
                ),
                label: Text(e.$2)))
            .toList(),
        selectedIndex: navigationShell.currentIndex);
  }
}
