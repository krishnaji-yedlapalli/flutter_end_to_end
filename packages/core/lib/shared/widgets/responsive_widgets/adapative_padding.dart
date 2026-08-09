import 'package:flutter/material.dart';
import 'package:app_core/core/device/config/device_configurations.dart';

class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double basePadding;

  const AdaptivePadding({
    Key? key,
    required this.child,
    this.padding,
    this.basePadding = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _getResponsivePadding(),
      child: child,
    );
  }

  EdgeInsets _getResponsivePadding() {
    // Use the new DeviceConfiguration system for responsive padding
    return DeviceConfiguration.getResponsivePadding(base: basePadding);
  }
}
