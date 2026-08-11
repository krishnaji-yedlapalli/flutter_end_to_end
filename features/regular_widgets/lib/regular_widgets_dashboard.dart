import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:app_core/core/routing/route_constants.dart';
import 'package:ui_kit/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:ui_kit/widgets/responsive_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class RegularlyUsedWidgetsDashboard extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;
  RegularlyUsedWidgetsDashboard({this.navigationShell, Key? key})
      : super(key: key);

  int selectedIndex = 0;
  final List<(IconData, String, String, String?)> navigationRails = [
    (
      Icons.design_services,
      'Material Components',
      RouteConstants.materialComponents,
      'Material Components'
    ),
    (
      Icons.design_services,
      'Cupertino Components',
      RouteConstants.cupertinoComponents,
      'Cupertino Components'
    ),
    (Icons.add_alert, 'Dialogs', RouteConstants.dialogs, 'Different types of Dialogs'),
    (
      Icons.animation,
      'Implicit Animations',
      RouteConstants.implicitAnimations,
      'Built in Animations'
    ),
    (
      Icons.animation,
      'Custom Implicit Animations',
      RouteConstants.customImplicitAnimations,
      'Customize the animations using tween builder'
    ),
    (
      Icons.animation,
      'Explicit Animations',
      RouteConstants.explicitAnimations,
      'Explicit Animations'
    ),
    (Icons.select_all, 'Tables', RouteConstants.tables, 'Tables'),
    (
      Icons.select_all,
      'Text Selection',
      RouteConstants.selectableText,
      'User can select the Text'
    ),
    (Icons.layers_outlined, 'Cards Layout', RouteConstants.cardLayouts, null),
    (Icons.send_time_extension, 'Stepper ', RouteConstants.stepper, 'Stepper View'),
    (Icons.model_training, 'Physical Model', RouteConstants.cupertinoComponents, null),
    if (DeviceConfiguration.isWeb)
      (Icons.html, 'Html', RouteConstants.htmlRendering, null),
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
    return AdaptiveLayoutBuilder(
      builder:
          (BuildContext context, DeviceResolutionType deviceResolutionType) {
        return switch (deviceResolutionType) {
          DeviceResolutionType.mobilePortrait => _buildPortraitListView(),
          DeviceResolutionType.tabletPortrait => _buildPortraitListView(),
          DeviceResolutionType.desktopStandard => _buildWebView(context),
          DeviceResolutionType.mobileLandscape => _buildWebView(context),
          DeviceResolutionType.tabletLandscape => _buildWebView(context),
          DeviceResolutionType.desktopLarge => _buildWebView(context),
        };
      },
    );
  }

  Widget _buildPortraitListView() {
    return ListView.builder(
        itemCount: navigationRails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
              leading: Icon(navigationRails.elementAt(index).$1),
              title: Text(navigationRails.elementAt(index).$2),
              onTap: () => context.push(
                  '/home/${RouteConstants.dashboard}/${navigationRails.elementAt(index).$3}'),
            ));
  }

  Widget _buildWebView(BuildContext context) {
    return Row(
      children: [
        _buildNavigationRail(context),
        Expanded(child: navigationShell ?? const SizedBox())
      ],
    );
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
          children: [
            const Icon(Icons.widgets, color: Colors.blue),
            Text('Widgets',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.apply(color: Colors.blue))
          ],
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
