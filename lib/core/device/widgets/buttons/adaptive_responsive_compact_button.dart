import 'package:flutter/material.dart';
import 'adaptive_responsive_button.dart';

/// Compact button variant for toolbars and tight spaces with smaller responsive text
class AdaptiveResponsiveCompactButton extends AdaptiveResponsiveButton {
  const AdaptiveResponsiveCompactButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isPrimary = true,
    IconData? icon,
    bool isFullWidth = false,
  }) : super(
          key: key,
          text: text,
          onPressed: onPressed,
          isPrimary: isPrimary,
          icon: icon,
          isFullWidth: isFullWidth,
          baseFontSize: 12.0, // Smaller base font size
          basePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          baseIconSize: 16.0, // Smaller icon size
        );
}
