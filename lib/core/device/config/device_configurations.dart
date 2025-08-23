import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../enums/device_enums.dart';
import '../utils/screen_break_points.dart';

class DeviceConfiguration {
  // Cached values
  static Size? _cachedSize;
  static Orientation? _cachedOrientation;
  static DeviceResolutionType? _cachedResolutionType;
  static double? _cachedWidth;
  static double? _cachedHeight;

  // Cache invalidation threshold (prevent micro-changes from invalidating cache)
  static const double _cacheThreshold = 5.0;

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

  /// Optimized update with caching and threshold checking
  static bool updateDeviceResolutionAndOrientation(
      Size size, Orientation orientation) {

    // Check if update is significant enough to invalidate cache
    bool shouldUpdate = _cachedSize == null ||
        _cachedOrientation != orientation ||
        (size.width - (_cachedWidth ?? 0)).abs() > _cacheThreshold ||
        (size.height - (_cachedHeight ?? 0)).abs() > _cacheThreshold;

    if (!shouldUpdate) {
      return false; // No significant change, cache is still valid
    }

    // Update cached values
    _cachedSize = size;
    _cachedOrientation = orientation;
    _cachedWidth = size.width;
    _cachedHeight = size.height;

    // Recalculate resolution type
    DeviceResolutionType newResolutionType;
    if (ScreenBreakPoints.isMobile(size)) {
      newResolutionType = DeviceResolutionType.mobile;
    } else if (ScreenBreakPoints.isDesktop(size)) {
      newResolutionType = DeviceResolutionType.desktop;
    } else {
      newResolutionType = DeviceResolutionType.tab;
    }

    bool resolutionChanged = _cachedResolutionType != newResolutionType;
    _cachedResolutionType = newResolutionType;

    return resolutionChanged; // Return true if resolution type actually changed
  }

  /// Cached getters - no MediaQuery calls needed
  static bool get isMobileResolution {
    assert(_cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.mobile;
  }

  static bool get isDesktopResolution {
    assert(_cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.desktop;
  }

  static bool get isTabResolution {
    assert(_cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType == DeviceResolutionType.tab;
  }

  static DeviceResolutionType get resolutionType {
    assert(_cachedResolutionType != null, 'DeviceConfiguration not initialized');
    return _cachedResolutionType!;
  }

  static bool get isPortrait {
    assert(_cachedOrientation != null, 'DeviceConfiguration not initialized');
    return _cachedOrientation == Orientation.portrait;
  }

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
        ? const EdgeInsets.all(16.0) // iOS/macOS standard
        : const EdgeInsets.all(12.0); // Material standard
  }

  /// Get platform-appropriate border radius
  static BorderRadius get platformBorderRadius {
    return useCupertinoDesign
        ? BorderRadius.circular(8.0) // iOS rounded corners
        : BorderRadius.circular(4.0); // Material corners
  }

  /// Get platform-appropriate elevation
  static double get platformElevation {
    return useCupertinoDesign
        ? 0.0 // iOS doesn't use elevation
        : 2.0; // Material elevation
  }

  /// Clear cache (useful for testing)
  static void clearCache() {
    _cachedSize = null;
    _cachedOrientation = null;
    _cachedResolutionType = null;
    _cachedWidth = null;
    _cachedHeight = null;
  }
}
