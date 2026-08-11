import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/material.dart';

/// Responsive title text widget with medium font size that adapts to screen size
class ResponsiveTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double? baseFontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final EdgeInsets? padding;
  final bool centerText;
  final TextDecoration? decoration;

  const ResponsiveTitle(
    this.text, {
    Key? key,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.baseFontSize,
    this.maxLines,
    this.overflow,
    this.padding,
    this.centerText = false,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = _getResponsiveFontSize();
    final responsivePadding = _getResponsivePadding();

    Widget textWidget = Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize,
        fontWeight: fontWeight ?? _getDefaultFontWeight(),
        color: color ?? _getDefaultColor(context),
        height: _getLineHeight(),
        decoration: decoration,
      ),
      textAlign: centerText ? TextAlign.center : (textAlign ?? TextAlign.start),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );

    return responsivePadding != null
        ? Padding(padding: responsivePadding, child: textWidget)
        : textWidget;
  }

  /// Calculate responsive font size for title
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 20.0; // Medium title size

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 4.0; // Larger on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 2.0; // Slightly larger on tablet
    } else if (DeviceConfiguration.isMobilePortrait) {
      baseSize -= 1.0; // Slightly smaller on mobile portrait
    }

    return DeviceConfiguration.getResponsiveFontSize(baseSize);
  }

  /// Get responsive padding if specified
  EdgeInsets? _getResponsivePadding() {
    if (padding == null) return null;

    return EdgeInsets.only(
      left: DeviceConfiguration.getResponsiveSpacing(padding!.left),
      top: DeviceConfiguration.getResponsiveSpacing(padding!.top),
      right: DeviceConfiguration.getResponsiveSpacing(padding!.right),
      bottom: DeviceConfiguration.getResponsiveSpacing(padding!.bottom),
    );
  }

  /// Get default font weight for title
  FontWeight _getDefaultFontWeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return FontWeight.w600; // Semi-bold on desktop
    }
    return FontWeight.w500; // Medium weight
  }

  /// Get default color based on theme
  Color? _getDefaultColor(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.color;
  }

  /// Get appropriate line height for titles
  double _getLineHeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return 1.25;
    } else if (DeviceConfiguration.isTabResolution) {
      return 1.3;
    }
    return 1.35;
  }
}
