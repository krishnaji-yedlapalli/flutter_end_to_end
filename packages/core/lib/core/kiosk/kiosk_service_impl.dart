import 'dart:async';
import 'dart:io';

import 'package:app_core/core/kiosk/controllers/backlight_controller.dart';
import 'package:app_core/core/kiosk/controllers/exit_gesture_detector.dart';
import 'package:app_core/core/kiosk/controllers/window_manager.dart';
import 'package:app_core/core/kiosk/kiosk_service.dart';
import 'package:app_core/core/kiosk/kiosk_state.dart';
import 'package:app_core/core/kiosk/services/deep_sleep_scheduler.dart';
import 'package:app_core/core/kiosk/services/inactivity_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Implementation of [IKioskService] that orchestrates all kiosk sub-components.
///
/// Acts as a facade over:
/// - [IBacklightController] for display sleep/wake
/// - [IInactivityTimer] for inactivity-based display sleep
/// - [IExitGestureDetector] for 5-tap exit gesture recognition
/// - [IDeepSleepScheduler] for scheduled shutdown/wake
/// - [IWindowManager] for fullscreen, cursor, and always-on-top management
///
/// Platform guard: on non-Linux platforms, all methods resolve immediately
/// with idle state and no side effects.
class KioskServiceImpl implements IKioskService {
  KioskServiceImpl({
    required IBacklightController backlightController,
    required IInactivityTimer inactivityTimer,
    required IExitGestureDetector exitGestureDetector,
    required IDeepSleepScheduler deepSleepScheduler,
    required IWindowManager windowManager,
  })  : _backlightController = backlightController,
        _inactivityTimer = inactivityTimer,
        _exitGestureDetector = exitGestureDetector,
        _deepSleepScheduler = deepSleepScheduler,
        _windowManager = windowManager {
    // Listen to inactivity timer expiry to trigger display sleep.
    if (_isLinux) {
      _inactivitySubscription = _inactivityTimer.onExpired.listen((_) {
        sleepDisplay();
      });
    }
  }

  final IBacklightController _backlightController;
  final IInactivityTimer _inactivityTimer;
  final IExitGestureDetector _exitGestureDetector;
  final IDeepSleepScheduler _deepSleepScheduler;
  final IWindowManager _windowManager;

  final StreamController<KioskState> _stateController =
      StreamController<KioskState>.broadcast(sync: true);

  StreamSubscription<void>? _inactivitySubscription;

  KioskState _currentState = const KioskState();
  bool _isDisposed = false;

  /// Platform guard — only activate kiosk behaviors on Linux.
  bool get _isLinux => !kIsWeb && Platform.isLinux;

  @override
  Stream<KioskState> get stateStream => _stateController.stream;

  @override
  KioskState get currentState => _currentState;

  @override
  DeepSleepSchedule get schedule => _deepSleepScheduler.schedule;

  @override
  Future<void> enterKioskMode() async {
    if (_isDisposed) return;

    // Platform guard: on non-Linux, resolve immediately with idle state.
    if (!_isLinux) {
      _emitState(_currentState.copyWith(mode: KioskMode.idle));
      return;
    }

    // Enter fullscreen, hide cursor, set always on top.
    await _windowManager.enterFullscreen();
    await _windowManager.hideCursor();
    await _windowManager.setAlwaysOnTop(true);

    // Start inactivity timer with the configured timeout.
    _inactivityTimer.start(_currentState.inactivityTimeout);

    // Configure default deep sleep schedule: shutdown at 11 PM, wake at 5:30 AM.
    await _deepSleepScheduler
        .setShutdownTime(const TimeOfDay(hour: 23, minute: 0));
    await _deepSleepScheduler
        .setWakeUpTime(const TimeOfDay(hour: 5, minute: 30));
    await _deepSleepScheduler.setEnabled(true);

    // Start deep sleep monitoring.
    _deepSleepScheduler.startMonitoring();

    // Emit active state.
    _emitState(_currentState.copyWith(
      mode: KioskMode.active,
      displayState: DisplayState.awake,
    ));
  }

  @override
  Future<void> exitKioskMode() async {
    if (_isDisposed) return;

    if (!_isLinux) {
      _emitState(_currentState.copyWith(mode: KioskMode.idle));
      return;
    }

    // Restore window state.
    await _windowManager.exitFullscreen();
    await _windowManager.showCursor();
    await _windowManager.setAlwaysOnTop(false);

    // Stop timers and monitoring.
    _inactivityTimer.stop();
    _deepSleepScheduler.stopMonitoring();
    _exitGestureDetector.reset();

    // Emit idle state before exiting.
    _emitState(_currentState.copyWith(mode: KioskMode.idle));

    // Clean exit for systemd (exit code 0 = no restart).
    exit(0);
  }

  @override
  Future<void> sleepDisplay() async {
    if (_isDisposed) return;

    if (!_isLinux) return;

    // Only sleep if currently awake.
    if (_currentState.displayState == DisplayState.sleeping) return;

    await _backlightController.turnOff();

    _emitState(_currentState.copyWith(displayState: DisplayState.sleeping));
  }

  @override
  Future<void> wakeDisplay() async {
    if (_isDisposed) return;

    if (!_isLinux) return;

    // Only wake if currently sleeping.
    if (_currentState.displayState == DisplayState.awake) return;

    await _backlightController.turnOn();

    _emitState(_currentState.copyWith(displayState: DisplayState.awake));
  }

  @override
  void setInactivityTimeout(Duration duration) {
    if (_isDisposed) return;

    _emitState(_currentState.copyWith(inactivityTimeout: duration));

    // If the timer is running, restart it with the new duration.
    if (_isLinux && _inactivityTimer.isRunning) {
      _inactivityTimer.start(duration);
    }
  }

  @override
  Future<void> setShutdownTime(TimeOfDay? time) async {
    if (_isDisposed) return;
    await _deepSleepScheduler.setShutdownTime(time);
  }

  @override
  Future<void> setWakeUpTime(TimeOfDay? time) async {
    if (_isDisposed) return;
    await _deepSleepScheduler.setWakeUpTime(time);
  }

  @override
  Future<void> setDeepSleepEnabled(bool enabled) async {
    if (_isDisposed) return;
    await _deepSleepScheduler.setEnabled(enabled);
    _emitState(_currentState.copyWith(deepSleepEnabled: enabled));
  }

  @override
  bool onTouchEvent() {
    if (_isDisposed) return false;

    if (!_isLinux) return false;

    final now = DateTime.now();

    // If display is sleeping, wake it and consume the touch event.
    if (_currentState.displayState == DisplayState.sleeping) {
      wakeDisplay();
      _inactivityTimer.reset();
      _deepSleepScheduler.lastTouchTime = now;
      return true; // Touch consumed (wake touch).
    }

    // Display is awake — reset inactivity timer.
    _inactivityTimer.reset();

    // Update last touch time on deep sleep scheduler.
    _deepSleepScheduler.lastTouchTime = now;

    // Record tap in exit gesture detector.
    final exitRecognized = _exitGestureDetector.recordTap(now);

    if (exitRecognized) {
      exitKioskMode();
      return true; // Touch consumed (exit gesture).
    }

    return false; // Touch passes through.
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    _inactivitySubscription?.cancel();
    _inactivityTimer.dispose();
    _deepSleepScheduler.dispose();
    _exitGestureDetector.reset();

    await _stateController.close();
  }

  /// Emit a new state synchronously and update the current state snapshot.
  void _emitState(KioskState newState) {
    if (_isDisposed) return;
    _currentState = newState;
    _stateController.add(newState);
  }
}
