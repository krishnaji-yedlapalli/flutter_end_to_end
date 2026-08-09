import 'package:flutter/material.dart';
import 'package:app_core/core/device/config/device_configurations.dart';

/// Responsive subtitle text widget with small-medium font size that adapts to screen size
class ResponsiveSubtitle extends StatelessWidget {
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
  final FontStyle? fontStyle;

  const ResponsiveSubtitle(
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
    this.fontStyle,
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
        fontStyle: fontStyle,
      ),
      textAlign: centerText ? TextAlign.center : (textAlign ?? TextAlign.start),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );

    return responsivePadding != null
        ? Padding(padding: responsivePadding, child: textWidget)
        : textWidget;
  }

  /// Calculate responsive font size for subtitle
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 16.0; // Small-medium subtitle size

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 3.0; // Larger on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 1.5; // Slightly larger on tablet
    } else if (DeviceConfiguration.isMobilePortrait) {
      baseSize -= 0.5; // Slightly smaller on mobile portrait
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

  /// Get default font weight for subtitle
  FontWeight _getDefaultFontWeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return FontWeight.w500; // Medium weight on desktop
    }
    return FontWeight.w400; // Normal weight
  }

  /// Get default color based on theme (usually secondary color)
  Color? _getDefaultColor(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.color ??
        Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .7);
  }

  /// Get appropriate line height for subtitles
  double _getLineHeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return 1.3;
    } else if (DeviceConfiguration.isTabResolution) {
      return 1.35;
    }
    return 1.4;
  }
}
