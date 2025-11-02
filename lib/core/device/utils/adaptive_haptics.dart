import 'package:flutter/services.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

/// Adaptive haptic feedback helper
class AdaptiveHaptics {
  static void lightImpact() {
    if (DeviceConfiguration.supportsHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  static void mediumImpact() {
    if (DeviceConfiguration.supportsHapticFeedback) {
      HapticFeedback.mediumImpact();
    }
  }

  static void heavyImpact() {
    if (DeviceConfiguration.supportsHapticFeedback) {
      HapticFeedback.heavyImpact();
    }
  }

  static void selectionClick() {
    if (DeviceConfiguration.supportsHapticFeedback) {
      HapticFeedback.selectionClick();
    }
  }

  static void vibrate() {
    if (DeviceConfiguration.supportsHapticFeedback) {
      HapticFeedback.vibrate();
    }
  }
}
