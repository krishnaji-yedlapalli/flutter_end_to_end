import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/mixins/feature_discovery_mixin.dart';
import 'package:app_core/shared/mixins/mixins.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:feature_discovery_module/home_feature_discovery.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget
    with CustomDialogs
    implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.title,
    required this.onRemoteConfigTap,
    required this.onAppsTap,
    required this.onFeatureTourTap,
  });

  final String title;
  final VoidCallback onRemoteConfigTap;
  final void Function(String) onAppsTap;
  final VoidCallback onFeatureTourTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Text(title),
      appBar: AppBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune),
          tooltip: 'Remote Config Overrides',
          onPressed: onRemoteConfigTap,
        ),
        DeviceConfiguration.isWeb
            ? HomeScreenFeatureDiscovery().aboutAppsDiscovery(onAppsTap)
            : _FeatureTourButton(onTap: onFeatureTourTap),
      ],
    );
  }
}

class _FeatureTourButton extends StatelessWidget with FeatureDiscovery {
  const _FeatureTourButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => featureDiscovery(onTap);
}
