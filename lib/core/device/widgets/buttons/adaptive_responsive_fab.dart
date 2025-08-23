import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../config/device_configurations.dart';

/// Adaptive responsive floating action button with platform-specific styling and responsive sizing
class AdaptiveResponsiveFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isExtended;
  final String? label;
  final double? baseIconSize;
  final double? baseFontSize;

  const AdaptiveResponsiveFAB({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isExtended = false,
    this.label,
    this.baseIconSize,
    this.baseFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate responsive sizes
    final responsiveIconSize = _getResponsiveIconSize();
    final responsiveFontSize = _getResponsiveFontSize();

    Widget fab = DeviceConfiguration.useCupertinoDesign
        ? _buildCupertinoFAB(responsiveIconSize, responsiveFontSize)
        : _buildMaterialFAB(context, responsiveIconSize, responsiveFontSize);

    return tooltip != null
        ? Tooltip(message: tooltip!, child: fab)
        : fab;
  }

  /// Calculate responsive icon size
  double _getResponsiveIconSize() {
    double baseSize = baseIconSize ?? 24.0;
    
    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 4.0;
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 2.0;
    }
    
    return DeviceConfiguration.getResponsiveIconSize(baseSize);
  }

  /// Calculate responsive font size for extended FAB
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 14.0;
    
    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 2.0;
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 1.0;
    }
    
    return DeviceConfiguration.getResponsiveFontSize(baseSize);
  }

  /// Build Cupertino-style FAB
  Widget _buildCupertinoFAB(double iconSize, double fontSize) {
    final responsivePadding = DeviceConfiguration.getResponsivePadding(
      horizontal: isExtended ? 16.0 : 12.0,
      vertical: 12.0,
    );

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(isExtended ? 28.0 : iconSize + 16.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: responsivePadding,
        minSize: 0,
        child: isExtended && label != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: CupertinoColors.white,
                  ),
                  SizedBox(width: DeviceConfiguration.getResponsiveSpacing(8.0)),
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Icon(
                icon,
                size: iconSize,
                color: CupertinoColors.white,
              ),
      ),
    );
  }

  /// Build Material-style FAB
  Widget _buildMaterialFAB(BuildContext context, double iconSize, double fontSize) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Text(
          label!,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: DeviceConfiguration.platformElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
      );
    }

    // Determine FAB size based on device type
    if (DeviceConfiguration.isDesktopResolution || DeviceConfiguration.isTabletLandscape) {
      return FloatingActionButton.large(
        onPressed: onPressed,
        elevation: DeviceConfiguration.platformElevation,
        child: Icon(icon, size: iconSize),
      );
    } else if (DeviceConfiguration.isMobilePortrait) {
      return FloatingActionButton.small(
        onPressed: onPressed,
        elevation: DeviceConfiguration.platformElevation,
        child: Icon(icon, size: iconSize * 0.8), // Slightly smaller icon for small FAB
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      elevation: DeviceConfiguration.platformElevation,
      child: Icon(icon, size: iconSize),
    );
  }
}
