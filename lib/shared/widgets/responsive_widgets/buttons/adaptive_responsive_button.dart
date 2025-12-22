import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

/// Adaptive responsive button that combines platform-specific styling with responsive sizing
class AdaptiveResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isFullWidth;
  final double? baseFontSize;
  final EdgeInsets? basePadding;
  final double? baseIconSize;

  const AdaptiveResponsiveButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isFullWidth = false,
    this.baseFontSize,
    this.basePadding,
    this.baseIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive padding
    const responsivePadding = EdgeInsets.all(0);

    // Build button content with responsive sizing
    Widget buttonChild = _buildButtonContent();

    // Platform-specific button implementation
    Widget button = DeviceConfiguration.useCupertinoDesign
        ? _buildCupertinoButton(buttonChild, responsivePadding)
        : _buildMaterialButton(buttonChild, responsivePadding);

    // Apply full width if needed
    return button;
  }

  /// Build button content with responsive text and icon
  Widget _buildButtonContent() {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );

    return textWidget;
  }

  /// Build Cupertino (iOS/macOS) button
  Widget _buildCupertinoButton(Widget child, EdgeInsets padding) {
    if (isPrimary) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        padding: padding,
        borderRadius: DeviceConfiguration.platformBorderRadius,
        child: child,
      );
    } else {
      return CupertinoButton(
        onPressed: onPressed,
        padding: padding,
        child: child,
      );
    }
  }

  /// Build Material (Android/Web) button
  Widget _buildMaterialButton(Widget child, EdgeInsets padding) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: DeviceConfiguration.platformBorderRadius,
          ),
          elevation: DeviceConfiguration.platformElevation,
        ),
        child: child,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: DeviceConfiguration.platformBorderRadius,
          ),
        ),
        child: child,
      );
    }
  }
}
