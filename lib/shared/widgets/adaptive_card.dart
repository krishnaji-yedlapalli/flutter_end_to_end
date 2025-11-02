import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

/// Adaptive card with platform-appropriate styling
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AdaptiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? DeviceConfiguration.platformPadding;

    if (DeviceConfiguration.useCupertinoDesign) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: DeviceConfiguration.platformBorderRadius,
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      );
    } else {
      return Card(
        elevation: DeviceConfiguration.platformElevation,
        shape: RoundedRectangleBorder(
          borderRadius: DeviceConfiguration.platformBorderRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: DeviceConfiguration.platformBorderRadius,
          child: Padding(
            padding: effectivePadding,
            child: child,
          ),
        ),
      );
    }
  }
}
