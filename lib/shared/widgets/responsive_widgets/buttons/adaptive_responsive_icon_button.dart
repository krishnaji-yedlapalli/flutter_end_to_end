import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

/// Icon-only button that adapts to platform and screen size with responsive icon sizing
class AdaptiveResponsiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isPrimary;
  final double? baseIconSize;
  final EdgeInsets? basePadding;

  const AdaptiveResponsiveIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isPrimary = false,
    this.baseIconSize,
    this.basePadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate responsive icon size
    final responsiveIconSize = _getResponsiveIconSize();

    // Calculate responsive padding
    final responsivePadding = _getResponsivePadding();

    Widget button = DeviceConfiguration.useCupertinoDesign
        ? _buildCupertinoIconButton(responsiveIconSize, responsivePadding)
        : _buildMaterialIconButton(
            context, responsiveIconSize, responsivePadding);

    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }

  /// Calculate responsive icon size based on device type
  double _getResponsiveIconSize() {
    double baseSize = baseIconSize ?? 24.0;

    // Device-specific icon size adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 4.0; // Larger icons on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 2.0; // Slightly larger on tablet
    } else if (DeviceConfiguration.isMobilePortrait) {
      baseSize -= 2.0; // Slightly smaller on mobile portrait
    }

    return DeviceConfiguration.getResponsiveIconSize(baseSize);
  }

  /// Calculate responsive padding
  EdgeInsets _getResponsivePadding() {
    if (basePadding != null) {
      return EdgeInsets.only(
        left: DeviceConfiguration.getResponsiveSpacing(basePadding!.left),
        top: DeviceConfiguration.getResponsiveSpacing(basePadding!.top),
        right: DeviceConfiguration.getResponsiveSpacing(basePadding!.right),
        bottom: DeviceConfiguration.getResponsiveSpacing(basePadding!.bottom),
      );
    }

    double basePaddingValue = 8.0;

    // Device-specific padding adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      basePaddingValue += 4.0;
    } else if (DeviceConfiguration.isTabResolution) {
      basePaddingValue += 2.0;
    }

    return DeviceConfiguration.getResponsivePadding(base: basePaddingValue);
  }

  /// Build Cupertino icon button
  Widget _buildCupertinoIconButton(double iconSize, EdgeInsets padding) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      minimumSize: Size.square(iconSize + padding.vertical),
      child: Icon(
        icon,
        size: iconSize,
        color: isPrimary ? CupertinoColors.activeBlue : null,
      ),
    );
  }

  /// Build Material icon button
  Widget _buildMaterialIconButton(
      BuildContext context, double iconSize, EdgeInsets padding) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      padding: padding,
      constraints: BoxConstraints(
        minWidth: iconSize + padding.horizontal,
        minHeight: iconSize + padding.vertical,
      ),
      style: isPrimary
          ? IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: DeviceConfiguration.platformBorderRadius,
              ),
            )
          : IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: DeviceConfiguration.platformBorderRadius,
              ),
            ),
    );
  }
}
