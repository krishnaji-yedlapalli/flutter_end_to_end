import 'package:flutter/material.dart';
import 'adaptive_responsive_button.dart';

/// Large button variant for primary actions with bigger responsive text
class AdaptiveResponsiveLargeButton extends AdaptiveResponsiveButton {
  const AdaptiveResponsiveLargeButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isPrimary = true,
    IconData? icon,
  }) : super(
          key: key,
          text: text,
          onPressed: onPressed,
          isPrimary: isPrimary,
          icon: icon,
          isFullWidth: true,
          baseFontSize: 18.0, // Larger base font size
          basePadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          baseIconSize: 24.0, // Larger icon size
        );
}
