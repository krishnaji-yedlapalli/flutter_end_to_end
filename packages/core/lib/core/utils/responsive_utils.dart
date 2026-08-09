import 'package:flutter/material.dart';

import '../constants/responsive_constants.dart';
import '../device/config/device_configurations.dart';

/// Enhanced ResponsiveUtils using the new 6-category resolution system
class ResponsiveUtils {
  /// Get scale factor using the new DeviceConfiguration system
  static double getScaleFactor(BuildContext context) {
    return DeviceConfiguration.getResponsiveScaleFactor();
  }

  /// Get responsive font size using the new system
  static double getResponsiveFontSize(double baseSize, BuildContext context) {
    return DeviceConfiguration.getResponsiveFontSize(baseSize);
  }

  /// Get responsive padding using the new system
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    double base = ResponsiveConstants.defaultBasePadding,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return DeviceConfiguration.getResponsivePadding(
      base: base,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /// Get responsive spacing using the new system
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return DeviceConfiguration.getResponsiveSpacing(baseSpacing);
  }

  /// Get responsive icon size using the new system
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    return DeviceConfiguration.getResponsiveIconSize(baseSize);
  }

  /// Get grid column count for current resolution
  static int getGridColumnCount(BuildContext context) {
    return DeviceConfiguration.getGridColumnCount();
  }

  /// Convenience methods for checking device types
  static bool isMobile(BuildContext context) {
    return DeviceConfiguration.isMobileResolution;
  }

  static bool isTablet(BuildContext context) {
    return DeviceConfiguration.isTabResolution;
  }

  static bool isDesktop(BuildContext context) {
    return DeviceConfiguration.isDesktopResolution;
  }

  /// Specific resolution type checks
  static bool isTabletLandscape(BuildContext context) {
    return DeviceConfiguration.isTabletLandscape;
  }

  static bool isTabletPortrait(BuildContext context) {
    return DeviceConfiguration.isTabletPortrait;
  }

  /// Get responsive width percentage
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return DeviceConfiguration.screenWidth * (percentage / 100);
  }

  /// Get responsive height percentage
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return DeviceConfiguration.screenHeight * (percentage / 100);
  }
}
