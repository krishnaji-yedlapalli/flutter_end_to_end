import 'package:flutter/material.dart';
import 'package:sample_latest/core/constants/responsive_constants.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/device/enums/device_enums.dart';

/// Signature for the builder callback with enhanced device resolution types
typedef DeviceResolutionBuilderCallback = Widget Function(
  BuildContext context,
  DeviceResolutionType deviceResolutionType,
);

/// Enhanced adaptive layout builder that uses the new 6-category resolution system
class AdaptiveLayoutBuilder extends StatelessWidget {
  /// The builder function that returns a widget based on device resolution type
  final DeviceResolutionBuilderCallback builder;

  /// Whether to use cached device configuration (recommended for performance)
  final bool useCachedConfiguration;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.builder,
    this.useCachedConfiguration = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DeviceResolutionType deviceType;

        if (useCachedConfiguration) {
          // Use the cached device configuration for better performance
          deviceType = DeviceConfiguration.resolutionType;
        } else {
          // Calculate device type based on current constraints
          deviceType =
              _calculateDeviceType(constraints.maxWidth, constraints.maxHeight);
        }

        return builder(context, deviceType);
      },
    );
  }

  /// Calculate device type based on width and height (fallback method)
  DeviceResolutionType _calculateDeviceType(double width, double height) {
    bool isPortrait = height > width;

    // Mobile detection
    if (width < ResponsiveConstants.mobileMaxWidth) {
      return isPortrait
          ? DeviceResolutionType.mobilePortrait
          : DeviceResolutionType.mobileLandscape;
    }

    // Handle mobile landscape edge case
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

    return DeviceResolutionType.desktopLarge;
  }
}

/// Convenience builder for specific device types
class ResponsiveBuilder extends StatelessWidget {
  final Widget? mobile;
  final Widget? mobileLandscape;
  final Widget? tablet;
  final Widget? tabletLandscape;
  final Widget? desktop;
  final Widget? desktopLarge;
  final Widget fallback;

  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.mobileLandscape,
    this.tablet,
    this.tabletLandscape,
    this.desktop,
    this.desktopLarge,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceResolutionType.mobilePortrait:
            return mobile ?? fallback;
          case DeviceResolutionType.mobileLandscape:
            return mobileLandscape ?? mobile ?? fallback;
          case DeviceResolutionType.tabletPortrait:
            return tablet ?? fallback;
          case DeviceResolutionType.tabletLandscape:
            return tabletLandscape ?? tablet ?? fallback; // Your 7-inch case
          case DeviceResolutionType.desktopStandard:
            return desktop ?? fallback;
          case DeviceResolutionType.desktopLarge:
            return desktopLarge ?? desktop ?? fallback;
        }
      },
    );
  }
}

/// Simplified responsive builder for common use cases
class SimpleResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const SimpleResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      builder: (context, deviceType) {
        if (deviceType.isMobile) {
          return mobile;
        } else if (deviceType.isTablet) {
          return tablet ?? mobile;
        } else {
          return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}
