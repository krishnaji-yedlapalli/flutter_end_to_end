import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Adaptive responsive outline button with platform-specific styling and responsive text sizing
class AdaptiveResponsiveOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final double? baseFontSize;
  final EdgeInsets? basePadding;
  final double? baseIconSize;
  final Color? borderColor;
  final double? borderWidth;

  const AdaptiveResponsiveOutlineButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.baseFontSize,
    this.basePadding,
    this.baseIconSize,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate responsive sizes
    final responsiveTextSize = _getResponsiveTextSize();
    final responsivePadding = _getResponsivePadding();
    final responsiveIconSize = _getResponsiveIconSize();
    final responsiveBorderWidth = _getResponsiveBorderWidth();

    // Build button content
    Widget buttonChild =
        _buildButtonContent(responsiveTextSize, responsiveIconSize);

    // Platform-specific button implementation
    Widget button = DeviceConfiguration.useCupertinoDesign
        ? _buildCupertinoOutlineButton(
            context, buttonChild, responsivePadding, responsiveBorderWidth)
        : _buildMaterialOutlineButton(
            context, buttonChild, responsivePadding, responsiveBorderWidth);

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  /// Calculate responsive text size
  double _getResponsiveTextSize() {
    double baseSize = baseFontSize ?? 16.0;

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 2.0;
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 1.0;
    }

    return DeviceConfiguration.getResponsiveFontSize(baseSize);
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

    double horizontal = 20.0;
    double vertical = 12.0;

    // Device-specific padding adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      horizontal += 6.0;
      vertical += 3.0;
    } else if (DeviceConfiguration.isTabResolution) {
      horizontal += 3.0;
      vertical += 1.5;
    }

    return DeviceConfiguration.getResponsivePadding(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  /// Calculate responsive icon size
  double _getResponsiveIconSize() {
    double baseSize = baseIconSize ?? 20.0;

    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 4.0;
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 2.0;
    }

    return DeviceConfiguration.getResponsiveIconSize(baseSize);
  }

  /// Calculate responsive border width
  double _getResponsiveBorderWidth() {
    double baseWidth = borderWidth ?? 1.5;

    // Slightly thicker borders on larger screens
    if (DeviceConfiguration.isDesktopResolution) {
      baseWidth += 0.5;
    } else if (DeviceConfiguration.isTabResolution) {
      baseWidth += 0.25;
    }

    return baseWidth * DeviceConfiguration.getResponsiveScaleFactor();
  }

  /// Build button content with responsive text and icon
  Widget _buildButtonContent(double textSize, double iconSize) {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );

    if (icon == null) {
      return textWidget;
    }

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize),
        SizedBox(width: spacing),
        Flexible(child: textWidget),
      ],
    );
  }

  /// Build Cupertino outline button
  Widget _buildCupertinoOutlineButton(
    BuildContext context,
    Widget child,
    EdgeInsets padding,
    double borderWidth,
  ) {
    final effectiveBorderColor = borderColor ?? CupertinoColors.activeBlue;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        borderRadius: DeviceConfiguration.platformBorderRadius,
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: padding,
        child: DefaultTextStyle(
          style: TextStyle(
            color: effectiveBorderColor,
            fontSize: _getResponsiveTextSize(),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: effectiveBorderColor,
              size: _getResponsiveIconSize(),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Build Material outline button
  Widget _buildMaterialOutlineButton(
    BuildContext context,
    Widget child,
    EdgeInsets padding,
    double borderWidth,
  ) {
    final effectiveBorderColor = borderColor ?? Theme.of(context).primaryColor;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding,
        textStyle: TextStyle(fontSize: _getResponsiveTextSize()),
        foregroundColor: effectiveBorderColor,
        side: BorderSide(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DeviceConfiguration.platformBorderRadius,
        ),
      ),
      child: child,
    );
  }
}
