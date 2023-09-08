import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  DashboardScreen(this.navigationShell, {Key? key}) : super(key: key);

  int selectedIndex = 0;
  List<(IconData, String)> navigationRails = [
    (Icons.layers_outlined, 'Cards Layout'),
    (Icons.shortcut, 'Call Back Shortcuts'),
    (Icons.model_training, 'Physical Model'),
    (Icons.layers_outlined, 'Cards Layout'),
    (Icons.layers_outlined, 'Cards Layout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge?.apply(color: Colors.white)),
      ),
      body: Row(
        children: [_buildNavigationRail(), Expanded(child: navigationShell)],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
        elevation: 5,

        backgroundColor: Colors.green.withOpacity(0.5),
        // extended: true,
        labelType: NavigationRailLabelType.all,
        minWidth: 100,
        onDestinationSelected: (index) {
          selectedIndex = index;
          navigationShell.goBranch(index);
        },
        destinations: navigationRails.map((e) => NavigationRailDestination(icon: Icon(e.$1, ),
            label: Text(e.$2))).toList(),
        selectedIndex: navigationShell.currentIndex);
  }
}
