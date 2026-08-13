import 'package:flutter/material.dart';

/// Represents whether the kiosk is idle or actively running in kiosk mode.
enum KioskMode { idle, active }

/// Represents the current state of the display backlight.
enum DisplayState { awake, sleeping }

/// Immutable state object representing the current kiosk configuration and status.
class KioskState {
  final KioskMode mode;
  final DisplayState displayState;
  final bool deepSleepEnabled;
  final Duration inactivityTimeout;

  const KioskState({
    this.mode = KioskMode.idle,
    this.displayState = DisplayState.awake,
    this.deepSleepEnabled = false,
    this.inactivityTimeout = const Duration(minutes: 10),
  });

  KioskState copyWith({
    KioskMode? mode,
    DisplayState? displayState,
    bool? deepSleepEnabled,
    Duration? inactivityTimeout,
  }) {
    return KioskState(
      mode: mode ?? this.mode,
      displayState: displayState ?? this.displayState,
      deepSleepEnabled: deepSleepEnabled ?? this.deepSleepEnabled,
      inactivityTimeout: inactivityTimeout ?? this.inactivityTimeout,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KioskState &&
        other.mode == mode &&
        other.displayState == displayState &&
        other.deepSleepEnabled == deepSleepEnabled &&
        other.inactivityTimeout == inactivityTimeout;
  }

  @override
  int get hashCode => Object.hash(
        mode,
        displayState,
        deepSleepEnabled,
        inactivityTimeout,
      );

  @override
  String toString() => 'KioskState(mode: $mode, displayState: $displayState, '
      'deepSleepEnabled: $deepSleepEnabled, '
      'inactivityTimeout: $inactivityTimeout)';
}

/// Configuration for the scheduled deep sleep feature.
///
/// Defines when the Raspberry Pi should shut down and wake up daily.
class DeepSleepSchedule {
  final TimeOfDay? shutdownTime;
  final TimeOfDay? wakeUpTime;
  final bool enabled;

  const DeepSleepSchedule({
    this.shutdownTime,
    this.wakeUpTime,
    this.enabled = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeepSleepSchedule &&
        other.shutdownTime == shutdownTime &&
        other.wakeUpTime == wakeUpTime &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(shutdownTime, wakeUpTime, enabled);

  @override
  String toString() => 'DeepSleepSchedule(shutdownTime: $shutdownTime, '
      'wakeUpTime: $wakeUpTime, enabled: $enabled)';
}
