import 'package:flutter/material.dart';

import '../enums/device_enums.dart';
import '../utils/screen_break_points.dart';

/// Signature for the builder callback
typedef DeviceResolutionBuilderCallback = Widget Function(
  BuildContext context,
  DeviceResolutionType deviceResolutionType,
);

/// A widget that builds different layouts based on screen width
class AdaptiveLayoutBuilder extends StatelessWidget {
  /// The builder function that returns a widget based on device type
  final DeviceResolutionBuilderCallback builder;

  /// Breakpoint for mobile width (default: 600)
  final double mobileBreakpoint;

  /// Breakpoint for tablet width (default: 900)
  final double tabletBreakpoint;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.builder,
    this.mobileBreakpoint = ScreenBreakPoints.mobileBreakPoint,
    this.tabletBreakpoint = ScreenBreakPoints.tabletBreakPoint,
  });

  /// Determines the device type based on screen width
  DeviceResolutionType _getDeviceType(double width) {
    if (width < mobileBreakpoint) {
      return DeviceResolutionType.mobile;
    } else if (width > mobileBreakpoint &&
        width < ScreenBreakPoints.desktopBreakPoint) {
      return DeviceResolutionType.tab;
    } else {
      return DeviceResolutionType.desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        return builder(context, deviceType);
      },
    );
  }
}
