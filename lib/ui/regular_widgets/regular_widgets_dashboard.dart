import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/routing.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class RegularlyUsedWidgetsDashboard extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;
  RegularlyUsedWidgetsDashboard({this.navigationShell, Key? key}) : super(key: key);

  int selectedIndex = 0;
  List<(IconData, String, String, String?)> navigationRails = [
    (Icons.design_services, 'Material Components', Routing.materialComponents, 'Material Components'),
    (Icons.design_services, 'Cupertino Components', Routing.cupertinoComponents, 'Cupertino Components'),
    (Icons.add_alert, 'Dialogs', Routing.dialogs, 'Different types of Dialogs'),
    (Icons.animation, 'Implicit Animations', Routing.implicitAnimations, 'Built in Animations'),
    (Icons.animation, 'Custom Implicit Animations', Routing.customImplicitAnimations, 'Customize the animations using tween builder'),
    (Icons.animation, 'Explicit Animations', Routing.explicitAnimations, 'Explicit Animations'),
    (Icons.select_all, 'Tables', Routing.tables, 'Tables'),
    (Icons.select_all, 'Text Selection', Routing.selectableText, 'User can select the Text'),
    (Icons.layers_outlined, 'Cards Layout', Routing.cardLayouts, null),
    (Icons.send_time_extension, 'Stepper ', Routing.stepper, 'Stepper View'),
    (Icons.model_training, 'Physical Model', Routing.cupertinoComponents, null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: const Text('Commonly Used Widgets'),
          appBar: AppBar(),
        ),
        body: _buildView(context));
  }

  Widget _buildView(BuildContext context) {
    switch (DeviceConfiguration.resolutionType) {
      case DeviceResolutionType.mobile:
      case DeviceResolutionType.tab:
      case DeviceResolutionType.desktop:
    }

    return switch (DeviceConfiguration.resolutionType) { DeviceResolutionType.mobile => _buildPortraitListView(), DeviceResolutionType.tab when DeviceConfiguration.isPortrait => _buildPortraitListView(), DeviceResolutionType.tab when !DeviceConfiguration.isPortrait => _buildWebView(context), DeviceResolutionType.desktop => _buildWebView(context), _ => Container() };
  }

  Widget _buildPortraitListView() {
    return ListView.builder(
        itemCount: navigationRails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
              leading: Icon(navigationRails.elementAt(index).$1),
              title: Text(navigationRails.elementAt(index).$2),
              onTap: () => context.push('/home/${Routing.dashboard}/${navigationRails.elementAt(index).$3}'),
            ));
  }

  Widget _buildWebView(BuildContext context) {
    return Row(
      children: [_buildNavigationRail(context), Expanded(child: navigationShell ?? const SizedBox())],
    );
  }

  Widget _buildLandScapeListView() {
    return Row(children: [ListView.builder(itemCount: navigationRails.length, itemBuilder: (context, index) => ListTile()), Expanded(child: SizedBox())]);
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
        extended: true,
        onDestinationSelected: (index) {
          selectedIndex = index;
          navigationShell?.goBranch(index);
        },
        leading: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [const Icon(Icons.widgets, color: Colors.blue), Text('Widgets', style: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.blue))],
        ),
        destinations: navigationRails
            .map((e) => NavigationRailDestination(
                icon: Icon(
                  e.$1,
                ),
                label: Text(e.$2)))
            .toList(),
        selectedIndex: navigationShell?.currentIndex);
  }

  void onDestinationSelection(index) {}
}
