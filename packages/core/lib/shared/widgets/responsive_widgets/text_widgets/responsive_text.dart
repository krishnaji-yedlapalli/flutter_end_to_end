import 'package:flutter/material.dart';
import 'package:app_core/core/device/config/device_configurations.dart';

/// Responsive body text widget with standard font size that adapts to screen size
class ResponsiveText extends StatelessWidget {
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
  final double? letterSpacing;
  final double? wordSpacing;
  final bool softWrap;

  const ResponsiveText(
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
    this.letterSpacing,
    this.wordSpacing,
    this.softWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = _getResponsiveFontSize();
    final responsivePadding = _getResponsivePadding();
    final responsiveLetterSpacing = _getResponsiveLetterSpacing();

    Widget textWidget = Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize,
        fontWeight: fontWeight ?? _getDefaultFontWeight(),
        color: color ?? _getDefaultColor(context),
        height: _getLineHeight(),
        decoration: decoration,
        fontStyle: fontStyle,
        letterSpacing: responsiveLetterSpacing,
        wordSpacing: wordSpacing,
      ),
      textAlign: centerText ? TextAlign.center : (textAlign ?? TextAlign.start),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );

    return responsivePadding != null
        ? Padding(padding: responsivePadding, child: textWidget)
        : textWidget;
  }

  /// Calculate responsive font size for body text
  double _getResponsiveFontSize() {
    double baseSize = baseFontSize ?? 14.0; // Standard body text size

    // Device-specific adjustments
    if (DeviceConfiguration.isDesktopResolution) {
      baseSize += 2.0; // Larger on desktop for better readability
    } else if (DeviceConfiguration.isTabResolution) {
      baseSize += 1.0; // Slightly larger on tablet
    }
    // Mobile keeps base size for optimal readability

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

  /// Get responsive letter spacing
  double? _getResponsiveLetterSpacing() {
    if (letterSpacing == null) return null;

    // Scale letter spacing with font size
    double scaleFactor = DeviceConfiguration.getResponsiveScaleFactor();
    return letterSpacing! * scaleFactor;
  }

  /// Get default font weight for body text
  FontWeight _getDefaultFontWeight() {
    return FontWeight.w400; // Normal weight for body text
  }

  /// Get default color based on theme
  Color? _getDefaultColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.color;
  }

  /// Get appropriate line height for body text
  double _getLineHeight() {
    // Better readability with appropriate line height
    if (DeviceConfiguration.isDesktopResolution) {
      return 1.5; // More spacing on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      return 1.45;
    }
    return 1.4; // Comfortable reading on mobile
  }
}

/// Specialized variants of ResponsiveText for common use cases

/// Small text variant for captions, labels, etc.
class ResponsiveSmallText extends ResponsiveText {
  const ResponsiveSmallText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
    EdgeInsets? padding,
    bool centerText = false,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double baseFontSize = 12.0,
  }) : super(
          text,
          key: key,
          textAlign: textAlign,
          color: color,
          fontWeight: fontWeight,
          baseFontSize: baseFontSize, // Smaller base size
          maxLines: maxLines,
          overflow: overflow,
          padding: padding,
          centerText: centerText,
          decoration: decoration,
          fontStyle: fontStyle,
        );
}

/// Large text variant for emphasis
class ResponsiveLargeText extends ResponsiveText {
  const ResponsiveLargeText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
    EdgeInsets? padding,
    bool centerText = false,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) : super(
          text,
          key: key,
          textAlign: textAlign,
          color: color,
          fontWeight: fontWeight ?? FontWeight.w500,
          baseFontSize: 18.0, // Larger base size
          maxLines: maxLines,
          overflow: overflow,
          padding: padding,
          centerText: centerText,
          decoration: decoration,
          fontStyle: fontStyle,
        );
}

/// Caption text variant for small descriptive text
class ResponsiveCaptionText extends ResponsiveText {
  const ResponsiveCaptionText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
    EdgeInsets? padding,
    bool centerText = false,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) : super(
          text,
          key: key,
          textAlign: textAlign,
          color: color,
          fontWeight: fontWeight,
          baseFontSize: 10.0, // Very small base size
          maxLines: maxLines,
          overflow: overflow,
          padding: padding,
          centerText: centerText,
          decoration: decoration,
          fontStyle: fontStyle ?? FontStyle.italic,
        );
}
