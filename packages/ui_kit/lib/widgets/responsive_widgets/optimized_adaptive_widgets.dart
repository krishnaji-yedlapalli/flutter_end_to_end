import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:flutter/material.dart';

/// Optimized AdaptivePadding that uses cached device configuration
class OptimizedAdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const OptimizedAdaptivePadding({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _getCachedPadding(),
      child: child,
    );
  }

  /// Uses cached device type instead of MediaQuery
  EdgeInsets _getCachedPadding() {
    // No MediaQuery call needed - uses cached value
    if (DeviceConfiguration.isMobileResolution) {
      return const EdgeInsets.all(8);
    } else if (DeviceConfiguration.isTabResolution) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(20);
    }
  }
}

/// Optimized AdaptiveContainer with cached calculations
class OptimizedAdaptiveContainer extends StatelessWidget {
  final Widget child;
  final double mobileWidth;
  final double tabletWidth;
  final double desktopWidth;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const OptimizedAdaptiveContainer({
    Key? key,
    required this.child,
    this.mobileWidth = 1,
    this.tabletWidth = 0.7,
    this.desktopWidth = 0.5,
    this.maxWidth,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _getCachedWidth(),
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      padding: padding,
      alignment: alignment,
      child: child,
    );
  }

  /// Uses cached screen width instead of MediaQuery
  double _getCachedWidth() {
    final screenWidth = DeviceConfiguration.screenWidth;

    if (DeviceConfiguration.isMobileResolution) {
      return screenWidth * mobileWidth;
    } else if (DeviceConfiguration.isTabResolution) {
      return screenWidth * tabletWidth;
    } else {
      return screenWidth * desktopWidth;
    }
  }
}

/// Optimized LayoutBuilder that only rebuilds when device type changes
class OptimizedAdaptiveLayoutBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, DeviceResolutionType deviceType)
      builder;

  const OptimizedAdaptiveLayoutBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<OptimizedAdaptiveLayoutBuilder> createState() =>
      _OptimizedAdaptiveLayoutBuilderState();
}

class _OptimizedAdaptiveLayoutBuilderState
    extends State<OptimizedAdaptiveLayoutBuilder> {
  DeviceResolutionType? _lastDeviceType;
  Widget? _cachedWidget;

  @override
  Widget build(BuildContext context) {
    final currentDeviceType = DeviceConfiguration.resolutionType;

    // Only rebuild if device type actually changed
    if (_lastDeviceType != currentDeviceType || _cachedWidget == null) {
      _cachedWidget = widget.builder(context, currentDeviceType);
      _lastDeviceType = currentDeviceType;
    }

    return _cachedWidget!;
  }
}

/// Mixin for widgets that need to respond to device type changes efficiently
mixin OptimizedDeviceAware<T extends StatefulWidget> on State<T> {
  DeviceResolutionType? _lastDeviceType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkDeviceTypeChange();
  }

  void _checkDeviceTypeChange() {
    final currentDeviceType = DeviceConfiguration.resolutionType;
    if (_lastDeviceType != currentDeviceType) {
      _lastDeviceType = currentDeviceType;
      onDeviceTypeChanged(currentDeviceType);
    }
  }

  /// Override this method to respond to device type changes
  void onDeviceTypeChanged(DeviceResolutionType newDeviceType) {}
}

/// Example usage of the mixin
// class ResponsiveWidget extends StatefulWidget {
//   @override
//   _ResponsiveWidgetState createState() => _ResponsiveWidgetState();
// }
//
// class _ResponsiveWidgetState extends State<ResponsiveWidget>
//     with OptimizedDeviceAware {
//
//   Widget? _cachedLayout;
//
//   @override
//   void onDeviceTypeChanged(DeviceResolutionType newDeviceType) {
//     // Only rebuild layout when device type actually changes
//     setState(() {
//       _cachedLayout = null; // Invalidate cache
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _cachedLayout ??= _buildLayoutForDeviceType();
//     return _cachedLayout!;
//   }
//
//   Widget _buildLayoutForDeviceType() {
//     switch (OptimizedDeviceConfiguration.resolutionType) {
//       case DeviceResolutionType.mobile:
//         return _buildMobileLayout();
//       case DeviceResolutionType.tab:
//         return _buildTabletLayout();
//       case DeviceResolutionType.desktop:
//         return _buildDesktopLayout();
//     }
//   }
//
//   Widget _buildMobileLayout() => Container(child: Text('Mobile Layout'));
//   Widget _buildTabletLayout() => Container(child: Text('Tablet Layout'));
//   Widget _buildDesktopLayout() => Container(child: Text('Desktop Layout'));
// }
