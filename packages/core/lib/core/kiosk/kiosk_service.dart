import 'package:app_core/core/kiosk/kiosk_state.dart';
import 'package:flutter/material.dart';

/// Public interface for the Kiosk Service facade.
///
/// Orchestrates fullscreen window management, inactivity-based display sleep,
/// touch wake with event consumption, exit gesture detection, and scheduled
/// deep sleep. Feature modules consume this via `get_it` dependency injection.
abstract class IKioskService {
  /// Current kiosk state as a stream
  Stream<KioskState> get stateStream;

  /// Current state snapshot
  KioskState get currentState;

  /// Enter kiosk mode: fullscreen, hide cursor, start inactivity timer
  Future<void> enterKioskMode();

  /// Exit kiosk mode: restore window, show cursor, stop timers
  Future<void> exitKioskMode();

  /// Manually sleep the display
  Future<void> sleepDisplay();

  /// Manually wake the display
  Future<void> wakeDisplay();

  /// Configure inactivity timeout duration
  void setInactivityTimeout(Duration duration);

  /// Configure scheduled shutdown time (null to clear)
  Future<void> setShutdownTime(TimeOfDay? time);

  /// Configure scheduled wake-up time (null to clear)
  Future<void> setWakeUpTime(TimeOfDay? time);

  /// Enable or disable scheduled deep sleep
  Future<void> setDeepSleepEnabled(bool enabled);

  /// Get current deep sleep schedule
  DeepSleepSchedule get schedule;

  /// Register a touch event (called by the gesture layer).
  /// Returns true if the touch was consumed (e.g., wake touch), false if it
  /// should pass through.
  bool onTouchEvent();

  /// Dispose all resources
  Future<void> dispose();
}
