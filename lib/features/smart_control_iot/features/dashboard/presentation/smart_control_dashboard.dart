import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/device/enums/device_enums.dart';
import '../../../../../core/device/widgets/adaptive_layout_builder.dart';
import '../../../../../core/mixins/cards_mixin.dart';
import '../../../core/smart_control_router_module.dart';
import '../../../shared/utils/enums.dart';

class SmartControlDashboard extends StatefulWidget {
  const SmartControlDashboard({super.key});

  @override
  State<SmartControlDashboard> createState() => _SmartControlDashboardState();
}

class _SmartControlDashboardState extends State<SmartControlDashboard>
    with CardWidgetsMixin {
  final List<(String, SmartControlType, IconData, {String? des})> screenTypes =
      [
    (
      'On and Off',
      SmartControlType.onOff,
      Icons.dashboard,
      des: 'We can on and off the light'
    ),
    (
      'On and Off',
      SmartControlType.motionDetector,
      Icons.dashboard,
      des: 'We can on and off the light'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AdaptiveLayoutBuilder(
            builder: (context, deviceType) => GridView.builder(
                itemCount: screenTypes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: switch (deviceType) {
                  DeviceResolutionType.mobile => 2,
                  DeviceResolutionType.tab => 3,
                  DeviceResolutionType.desktop => 5,
                }),
                itemBuilder: (_, index) {
                  var screenDetails = screenTypes.elementAt(index);
                  return buildHomeCardView(
                      key: Key(screenDetails.$2.name),
                      title: screenDetails.$1,
                      des: screenDetails.des ?? '',
                      icon: screenDetails.$3,
                      callback: () => navigateToControl(screenDetails.$2));
                })));
  }

  navigateToControl(SmartControlType type) {
    switch (type) {
      case SmartControlType.onOff:
        GoRouter.of(context).go(SmartControlRouterModule.onAndOffPath);
      case SmartControlType.motionDetector:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
