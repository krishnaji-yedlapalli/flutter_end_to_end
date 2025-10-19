enum OperatingSystemType {
  ios,
  android,
  androidFolded,
  windows,
  linux,
  macos,
  web
}

/// Enhanced resolution-based device categories
enum DeviceResolutionType {
  mobilePortrait, // < 600px width, portrait orientation
  mobileLandscape, // < 900px width, landscape orientation
  tabletPortrait, // 600-1024px width, portrait orientation
  tabletLandscape, // 1000-1400px width, landscape orientation
  desktopStandard, // 1400-2000px width (typical monitors)
  desktopLarge // > 2000px width (ultrawide/large displays)
}

enum ApplicationType { mobile, web, desktop }

/// Extension methods for easier device type checking
extension DeviceResolutionTypeExtension on DeviceResolutionType {
  bool get isMobile =>
      this == DeviceResolutionType.mobilePortrait ||
      this == DeviceResolutionType.mobileLandscape;

  bool get isTablet =>
      this == DeviceResolutionType.tabletPortrait ||
      this == DeviceResolutionType.tabletLandscape;

  bool get isDesktop =>
      this == DeviceResolutionType.desktopStandard ||
      this == DeviceResolutionType.desktopLarge;

  bool get isPortrait =>
      this == DeviceResolutionType.mobilePortrait ||
      this == DeviceResolutionType.tabletPortrait;

  bool get isLandscape =>
      this == DeviceResolutionType.mobileLandscape ||
      this == DeviceResolutionType.tabletLandscape;

  /// Get responsive scale factor for each resolution type
  double get scaleFactor {
    switch (this) {
      case DeviceResolutionType.mobilePortrait:
        return 1.0;
      case DeviceResolutionType.mobileLandscape:
        return 0.9;
      case DeviceResolutionType.tabletPortrait:
        return 1.1;
      case DeviceResolutionType.tabletLandscape:
        return 1.15; // Optimized for 7-inch landscape
      case DeviceResolutionType.desktopStandard:
        return 1.2;
      case DeviceResolutionType.desktopLarge:
        return 1.4;
    }
  }

  /// Get padding multiplier for each resolution type
  double get paddingMultiplier {
    switch (this) {
      case DeviceResolutionType.mobilePortrait:
        return 1.0;
      case DeviceResolutionType.mobileLandscape:
        return 0.8;
      case DeviceResolutionType.tabletPortrait:
        return 1.3;
      case DeviceResolutionType.tabletLandscape:
        return 1.5; // More padding for 7-inch landscape
      case DeviceResolutionType.desktopStandard:
        return 1.8;
      case DeviceResolutionType.desktopLarge:
        return 2.2;
    }
  }

  /// Get grid column count for each resolution type
  int get gridColumnCount {
    switch (this) {
      case DeviceResolutionType.mobilePortrait:
        return 1;
      case DeviceResolutionType.mobileLandscape:
        return 2;
      case DeviceResolutionType.tabletPortrait:
        return 2;
      case DeviceResolutionType.tabletLandscape:
        return 3; // Perfect for 7-inch landscape
      case DeviceResolutionType.desktopStandard:
        return 4;
      case DeviceResolutionType.desktopLarge:
        return 5;
    }
  }
}
