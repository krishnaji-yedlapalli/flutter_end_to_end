import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../config/device_configurations.dart';

/// Adaptive responsive button that combines platform-specific styling with responsive sizing
class AdaptiveResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isFullWidth;
  final double? baseFontSize;
  final EdgeInsets? basePadding;
  final double? baseIconSize;

  const AdaptiveResponsiveButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isFullWidth = false,
    this.baseFontSize,
    this.basePadding,
    this.baseIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive text size
    final responsiveTextSize = _getResponsiveTextSize();

    // Get responsive padding
    final responsivePadding = _getResponsivePadding();

    // Get responsive icon size
    final responsiveIconSize = _getResponsiveIconSize();

    // Build button content with responsive sizing
    Widget buttonChild = _buildButtonContent(
      responsiveTextSize,
      responsiveIconSize,
    );

    // Platform-specific button implementation
    Widget button = DeviceConfiguration.useCupertinoDesign
        ? _buildCupertinoButton(buttonChild, responsivePadding)
        : _buildMaterialButton(buttonChild, responsivePadding);

    // Apply full width if needed
    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  /// Calculate responsive text size based on device type and base size
  double _getResponsiveTextSize() {
    double baseSize = baseFontSize ?? (isPrimary ? 16.0 : 14.0);

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 2.0; // Larger text on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 1.0; // Slightly larger on tablet
    }

    // Apply responsive scaling
    return DeviceConfiguration.getResponsiveFontSize(baseSize);
  }

  /// Calculate responsive padding based on device type and base padding
  EdgeInsets _getResponsivePadding() {
    if (basePadding != null) {
      return EdgeInsets.only(
        left: DeviceConfiguration.getResponsiveSpacing(basePadding!.left),
        top: DeviceConfiguration.getResponsiveSpacing(basePadding!.top),
        right: DeviceConfiguration.getResponsiveSpacing(basePadding!.right),
        bottom: DeviceConfiguration.getResponsiveSpacing(basePadding!.bottom),
      );
    }

    // Default padding calculations
    double horizontal = isPrimary ? 24.0 : 16.0;
    double vertical = isPrimary ? 12.0 : 8.0;

    // Device-specific padding adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      horizontal += 8.0;
      vertical += 4.0;
    } else if (DeviceConfiguration.isTabResolution) {
      horizontal += 4.0;
      vertical += 2.0;
    }

    return DeviceConfiguration.getResponsivePadding(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  /// Calculate responsive icon size
  double _getResponsiveIconSize() {
    double baseSize = baseIconSize ?? 20.0;

    // Device-specific icon size adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 4.0;
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 2.0;
    }

    return DeviceConfiguration.getResponsiveIconSize(baseSize);
  }

  /// Build button content with responsive text and icon
  Widget _buildButtonContent(double textSize, double iconSize) {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );

    if (icon == null) {
      return textWidget;
    }

    // Responsive spacing between icon and text
    final spacing = DeviceConfiguration.getResponsiveSpacing(8.0);

    // For mobile portrait with long text, stack vertically
    if (DeviceConfiguration.isMobilePortrait && text.length > 8) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          SizedBox(height: spacing / 2),
          textWidget,
        ],
      );
    }

    // Default horizontal layout
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize),
        SizedBox(width: spacing),
        Flexible(child: textWidget),
      ],
    );
  }

  /// Build Cupertino (iOS/macOS) button
  Widget _buildCupertinoButton(Widget child, EdgeInsets padding) {
    if (isPrimary) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        padding: padding,
        borderRadius: DeviceConfiguration.platformBorderRadius,
        child: child,
      );
    } else {
      return CupertinoButton(
        onPressed: onPressed,
        padding: padding,
        child: child,
      );
    }
  }

  /// Build Material (Android/Web) button
  Widget _buildMaterialButton(Widget child, EdgeInsets padding) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          textStyle: TextStyle(fontSize: _getResponsiveTextSize()),
          shape: RoundedRectangleBorder(
            borderRadius: DeviceConfiguration.platformBorderRadius,
          ),
          elevation: DeviceConfiguration.platformElevation,
        ),
        child: child,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          textStyle: TextStyle(fontSize: _getResponsiveTextSize()),
          shape: RoundedRectangleBorder(
            borderRadius: DeviceConfiguration.platformBorderRadius,
          ),
        ),
        child: child,
      );
    }
  }
}
