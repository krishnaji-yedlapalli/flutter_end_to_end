import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/material.dart';

/// Responsive sub-header text widget with medium-large font size that adapts to screen size
class ResponsiveSubHeader extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double? baseFontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final EdgeInsets? padding;
  final bool centerText;

  const ResponsiveSubHeader(
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

  /// Calculate responsive font size for sub-header
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 24.0; // Medium-large size

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 6.0; // Larger on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 3.0; // Slightly larger on tablet
    } else if (DeviceConfiguration.isMobilePortrait) {
      baseSize -= 2.0; // Slightly smaller on mobile portrait
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

  /// Get default font weight for sub-header
  FontWeight _getDefaultFontWeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return FontWeight.w600; // Semi-bold on desktop
    }
    return FontWeight.w500; // Medium weight
  }

  /// Get default color based on theme
  Color? _getDefaultColor(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.color;
  }

  /// Get appropriate line height for sub-headers
  double _getLineHeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return 1.2;
    } else if (DeviceConfiguration.isTabResolution) {
      return 1.25;
    }
    return 1.3;
  }
}
