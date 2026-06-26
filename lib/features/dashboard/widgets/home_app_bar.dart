import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/mixins/feature_discovery_mixin.dart';
import 'package:sample_latest/shared/mixins/mixins.dart';
import 'package:sample_latest/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';

import '../../feature_discovery/home_feature_discovery.dart';

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
