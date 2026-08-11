import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/material.dart';

/// Responsive header text widget with large font size that adapts to screen size
class ResponsiveHeader extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double? baseFontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final EdgeInsets? padding;
  final bool centerText;

  const ResponsiveHeader(
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
      ),
      textAlign: centerText ? TextAlign.center : (textAlign ?? TextAlign.start),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );

    return responsivePadding != null
        ? Padding(padding: responsivePadding, child: textWidget)
        : textWidget;
  }

  /// Calculate responsive font size for header
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 32.0; // Large header size

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 8.0; // Much larger on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 4.0; // Larger on tablet
    } else if (DeviceConfiguration.isMobilePortrait) {
      baseSize -= 4.0; // Slightly smaller on mobile portrait
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

  /// Get default font weight for header
  FontWeight _getDefaultFontWeight() {
    // Headers should be bold by default
    if (DeviceConfiguration.isDesktopResolution) {
      return FontWeight.w700; // Bolder on desktop
    }
    return FontWeight.w600;
  }

  /// Get default color based on theme
  Color? _getDefaultColor(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge?.color;
  }

  /// Get appropriate line height for headers
  double _getLineHeight() {
    // Tighter line height for headers
    if (DeviceConfiguration.isDesktopResolution) {
      return 1.1;
    } else if (DeviceConfiguration.isTabResolution) {
      return 1.15;
    }
    return 1.2;
  }
}
