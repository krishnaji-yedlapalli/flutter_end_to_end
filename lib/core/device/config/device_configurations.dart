import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/core/constants/responsive_constants.dart';
import 'package:sample_latest/core/device/enums/device_enums.dart';

class DeviceConfiguration {
  // Cached values
  static Size? _cachedSize;
  static Orientation? _cachedOrientation;
  static DeviceResolutionType? _cachedResolutionType;
  static double? _cachedWidth;
  static double? _cachedHeight;
  static double? _cachedPixelRatio;

  // Static configuration (set once)
  static late OperatingSystemType _operatingType;
  static late ApplicationType _applicationType;

  DeviceConfiguration.initiate() {
    if (kIsWeb) {
      _operatingType = OperatingSystemType.web;
      _applicationType = ApplicationType.web;
    } else {
      _operatingType = OperatingSystemType.values.firstWhere((operatingType) =>
          operatingType.toString() ==
          'OperatingSystemType.${Platform.operatingSystem}');

      if (Platform.isIOS || Platform.isAndroid) {
        _applicationType = ApplicationType.mobile;
      } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
        _applicationType = ApplicationType.desktop;
      }
    }
  }

  /// Enhanced resolution-based update with 6 categories
  static bool updateDeviceResolutionAndOrientation(
      Size size, Orientation orientation,
      [double? pixelRatio]) {
    // Check if update is significant enough to invalidate cache
    bool shouldUpdate = _cachedSize == null ||
        _cachedOrientation != orientation ||
        (size.width - (_cachedWidth ?? 0)).abs() >
            ResponsiveConstants.cacheThreshold ||
        (size.height - (_cachedHeight ?? 0)).abs() >
            ResponsiveConstants.cacheThreshold;

    if (!shouldUpdate) {
      return false; // No significant change, cache is still valid
    }

    // Update cached values
    _cachedSize = size;
    _cachedOrientation = orientation;
    _cachedWidth = size.width;
    _cachedHeight = size.height;
    _cachedPixelRatio = pixelRatio ?? 1.0;

    // Enhanced resolution-based detection
    DeviceResolutionType newResolutionType =
        _determineResolutionType(size.width, size.height);

    bool resolutionChanged = _cachedResolutionType != newResolutionType;
    _cachedResolutionType = newResolutionType;

    return resolutionChanged; // Return true if resolution type actually changed
  }

  /// Smart resolution-based detection (6 categories)
  static DeviceResolutionType _determineResolutionType(
      double width, double height) {
    bool isPortrait = height > width;

    // Mobile detection
    if (width < ResponsiveConstants.mobileMaxWidth) {
      return isPortrait
          ? DeviceResolutionType.mobilePortrait
          : DeviceResolutionType.mobileLandscape;
    }

    // Handle mobile landscape edge case (very wide but short screens)
    if (!isPortrait &&
        width < ResponsiveConstants.mobileLandscapeMaxWidth &&
        height < ResponsiveConstants.mobileMaxWidth) {
      return DeviceResolutionType.mobileLandscape;
    }

    // Tablet detection
    if (width < ResponsiveConstants.tabletMaxWidth) {
      return isPortrait
          ? DeviceResolutionType.tabletPortrait
          : DeviceResolutionType.tabletLandscape;
    }

    // Desktop detection
    if (width < ResponsiveConstants.desktopStandardMaxWidth) {
      return DeviceResolutionType.desktopStandard;
    }

    // Large desktop
    return DeviceResolutionType.desktopLarge;
  }

  /// Get responsive scale factor based on current resolution type
  static double getResponsiveScaleFactor() {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!.scaleFactor;
  }

  /// Get responsive padding based on current resolution type
  static EdgeInsets getResponsivePadding({
    double base = ResponsiveConstants.defaultBasePadding,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');

    double scaleFactor = getResponsiveScaleFactor();
    double paddingMultiplier = _cachedResolutionType!.paddingMultiplier;
    double finalScale = scaleFactor * paddingMultiplier;

    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: (horizontal ?? base) * finalScale,
        vertical: (vertical ?? base) * finalScale,
      );
    }

    return EdgeInsets.only(
      left: (left ?? base) * finalScale,
      top: (top ?? base) * finalScale,
      right: (right ?? base) * finalScale,
      bottom: (bottom ?? base) * finalScale,
    );
  }

  /// Get responsive font size
  static double getResponsiveFontSize(double baseSize) {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return baseSize * getResponsiveScaleFactor();
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(double baseSpacing) {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return baseSpacing *
        getResponsiveScaleFactor() *
        _cachedResolutionType!.paddingMultiplier;
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(double baseSize) {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return baseSize * getResponsiveScaleFactor();
  }

  /// Get grid column count for current resolution
  static int getGridColumnCount() {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!.gridColumnCount;
  }

  // Enhanced getters with new resolution types
  static bool get isMobileResolution {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!.isMobile;
  }

  static bool get isDesktopResolution {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!.isDesktop;
  }

  static bool get isTabResolution {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!.isTablet;
  }

  // New specific getters
  static bool get isMobilePortrait {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.mobilePortrait;
  }

  static bool get isMobileLandscape {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.mobileLandscape;
  }

  static bool get isTabletPortrait {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.tabletPortrait;
  }

  static bool get isTabletLandscape {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.tabletLandscape;
  }

  static bool get isDesktopStandard {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.desktopStandard;
  }

  static bool get isDesktopLarge {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.desktopLarge;
  }

  static DeviceResolutionType get resolutionType {
    assert(
        _cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!;
  }

  static bool get isPortrait {
    assert(_cachedOrientation != null, 'DeviceConfiguration not initialized');
    return _cachedOrientation == Orientation.portrait;
  }

  static bool get isLandscape => !isPortrait;

  static Size get screenSize {
    assert(_cachedSize != null, 'DeviceConfiguration not initialized');
    return _cachedSize!;
  }

  static double get screenWidth {
    assert(_cachedWidth != null, 'DeviceConfiguration not initialized');
    return _cachedWidth!;
  }

  static double get screenHeight {
    assert(_cachedHeight != null, 'DeviceConfiguration not initialized');
    return _cachedHeight!;
  }

  // Static properties (unchanged)
  static bool get isWeb => _applicationType == ApplicationType.web;
  static OperatingSystemType get operatingSystemType => _operatingType;
  static bool get isiPhone => _operatingType == OperatingSystemType.ios;

  static bool get isOfflineSupportedDevice {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS || Platform.isAndroid;
  }

  // Platform-specific UI methods

  /// Returns true if the platform should use Cupertino (iOS/macOS) design
  static bool get useCupertinoDesign =>
      _operatingType == OperatingSystemType.ios ||
      _operatingType == OperatingSystemType.macos;

  /// Returns true if the platform should use Material design
  static bool get useMaterialDesign => !useCupertinoDesign;

  /// Returns true for Apple platforms (iOS/macOS)
  static bool get isApplePlatform =>
      _operatingType == OperatingSystemType.ios ||
      _operatingType == OperatingSystemType.macos;

  /// Returns true for Google platforms (Android/AndroidFolded)
  static bool get isGooglePlatform =>
      _operatingType == OperatingSystemType.android ||
      _operatingType == OperatingSystemType.androidFolded;

  /// Platform-specific capabilities

  /// Returns true if platform supports haptic feedback
  static bool get supportsHapticFeedback =>
      _operatingType == OperatingSystemType.ios ||
      _operatingType == OperatingSystemType.android ||
      _operatingType == OperatingSystemType.androidFolded;

  /// Returns true if platform supports system navigation bar customization
  static bool get supportsSystemNavigationBar =>
      _operatingType == OperatingSystemType.android ||
      _operatingType == OperatingSystemType.androidFolded;

  /// Returns true if platform supports status bar styling
  static bool get supportsStatusBarStyling =>
      _operatingType == OperatingSystemType.ios ||
      _operatingType == OperatingSystemType.android ||
      _operatingType == OperatingSystemType.androidFolded;

  /// Platform-specific design values

  /// Get platform-appropriate padding
  static EdgeInsets get platformPadding {
    return useCupertinoDesign
        ? const EdgeInsets.all(
            ResponsiveConstants.iosPadding) // iOS/macOS standard
        : const EdgeInsets.all(
            ResponsiveConstants.materialPadding); // Material standard
  }

  /// Get platform-appropriate border radius
  static BorderRadius get platformBorderRadius {
    return useCupertinoDesign
        ? BorderRadius.circular(
            ResponsiveConstants.iosBorderRadius) // iOS rounded corners
        : BorderRadius.circular(
            ResponsiveConstants.materialBorderRadius); // Material corners
  }

  /// Get platform-appropriate elevation
  static double get platformElevation {
    return useCupertinoDesign
        ? ResponsiveConstants.iosElevation // iOS doesn't use elevation
        : ResponsiveConstants.materialElevation; // Material elevation
  }

  /// Clear cache (useful for testing)
  static void clearCache() {
    _cachedSize = null;
    _cachedOrientation = null;
    _cachedResolutionType = null;
    _cachedWidth = null;
    _cachedHeight = null;
    _cachedPixelRatio = null;
  }
}
