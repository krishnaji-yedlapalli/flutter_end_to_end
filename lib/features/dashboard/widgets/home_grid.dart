import 'package:feature_discovery_module/home_feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
import 'package:app_core/shared/mixins/mixins.dart';
import 'package:app_core/shared/widgets/responsive_widgets/widgets.dart';

import '../constants/home_screen_items.dart';

class HomeGrid extends StatelessWidget with CardWidgetsMixin {
  const HomeGrid({super.key, required this.onItemTap});

  final void Function(ScreenType) onItemTap;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      builder: (context, deviceType) => Padding(
        padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
        child: GridView.builder(
          itemCount: homeScreenItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: switch (deviceType) {
              DeviceResolutionType.mobilePortrait => 2,
              DeviceResolutionType.mobileLandscape => 3,
              DeviceResolutionType.tabletPortrait => 3,
              DeviceResolutionType.tabletLandscape => 4,
              DeviceResolutionType.desktopStandard => 5,
              DeviceResolutionType.desktopLarge => 7,
            },
            crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8.0),
            mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8.0),
            childAspectRatio: _aspectRatio(deviceType),
          ),
          itemBuilder: (_, index) {
            final item = homeScreenItems[index];
            final module = buildHomeCardView(
              key: Key(item.$2.name),
              title: item.$1,
              des: item.des ?? '',
              icon: item.$3,
              callback: () => onItemTap(item.$2),
            );
            return HomeScreenFeatureDiscovery.features.contains(item.$2.name)
                ? HomeScreenFeatureDiscovery()
                    .aboutModuleDiscovery(module, item.$2)
                : module;
          },
        ),
      ),
    );
  }

  double _aspectRatio(DeviceResolutionType deviceType) => switch (deviceType) {
        DeviceResolutionType.mobilePortrait => 1.0,
        DeviceResolutionType.mobileLandscape => 1.1,
        DeviceResolutionType.tabletPortrait => 0.9,
        DeviceResolutionType.tabletLandscape => 1.0,
        DeviceResolutionType.desktopStandard => 1.0,
        DeviceResolutionType.desktopLarge => 1.1,
      };
}
