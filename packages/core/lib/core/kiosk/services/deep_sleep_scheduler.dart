import 'dart:async';

import 'package:app_core/core/kiosk/kiosk_state.dart';
import 'package:app_core/core/kiosk/platform/linux_process_runner.dart';
import 'package:app_core/core/kiosk/platform/sysfs_writer.dart';
import 'package:app_core/core/kiosk/services/schedule_persistence.dart';
import 'package:flutter/material.dart';

/// Path to the RTC wake alarm sysfs file.
const String kRtcWakeAlarmPath = '/sys/class/rtc/rtc0/wakealarm';

/// Interface for the deep sleep scheduler that manages scheduled shutdown and wake-up.
abstract class IDeepSleepScheduler {
  /// Set the daily shutdown time. Pass `null` to clear.
  Future<void> setShutdownTime(TimeOfDay? time);

  /// Set the daily wake-up time. Pass `null` to clear.
  Future<void> setWakeUpTime(TimeOfDay? time);

  /// Enable or disable the scheduler.
  Future<void> setEnabled(bool enabled);

  /// Get the current schedule configuration.
  DeepSleepSchedule get schedule;

  /// Start periodic monitoring (called when kiosk mode enters).
  void startMonitoring();

  /// Stop periodic monitoring.
  void stopMonitoring();

  /// Check if the user is actively interacting (touch within last 60 seconds).
  bool isUserActive(DateTime lastTouchTime);

  /// Calculate the epoch seconds for the next wake alarm occurrence.
  ///
  /// Returns the Unix epoch seconds for the next occurrence of [wakeTime]
  /// relative to [fromDate]. If the time hasn't passed today, returns today's
  /// occurrence; otherwise returns tomorrow's.
  int calculateWakeAlarmEpoch(TimeOfDay wakeTime, DateTime fromDate);

  /// Initiate the shutdown sequence: write RTC wake alarm, then shut down.
  Future<void> initiateShutdown();

  /// Dispose all resources (timers, etc.).
  void dispose();

  /// The last touch time, updated externally by the KioskService.
  DateTime? lastTouchTime;
}

/// Implementation of [IDeepSleepScheduler] with periodic monitoring,
/// active interaction detection, RTC wake alarm programming, and system shutdown.
class DeepSleepSchedulerImpl implements IDeepSleepScheduler {
  DeepSleepSchedulerImpl({
    required ISchedulePersistence persistence,
    required ISysfsWriter sysfsWriter,
    required ILinuxProcessRunner processRunner,
  })  : _persistence = persistence,
        _sysfsWriter = sysfsWriter,
        _processRunner = processRunner;

  final ISchedulePersistence _persistence;
  final ISysfsWriter _sysfsWriter;
  final ILinuxProcessRunner _processRunner;

  DeepSleepSchedule _schedule = const DeepSleepSchedule();
  Timer? _monitoringTimer;
  Timer? _delayedShutdownTimer;
  bool _isDisposed = false;

  @override
  DateTime? lastTouchTime;

  @override
  DeepSleepSchedule get schedule => _schedule;

  @override
  Future<void> setShutdownTime(TimeOfDay? time) async {
    _schedule = DeepSleepSchedule(
      shutdownTime: time,
      wakeUpTime: _schedule.wakeUpTime,
      enabled: _schedule.enabled,
    );
    await _persistence.saveSchedule(_schedule);
  }

  @override
  Future<void> setWakeUpTime(TimeOfDay? time) async {
    _schedule = DeepSleepSchedule(
      shutdownTime: _schedule.shutdownTime,
      wakeUpTime: time,
      enabled: _schedule.enabled,
    );
    await _persistence.saveSchedule(_schedule);
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    _schedule = DeepSleepSchedule(
      shutdownTime: _schedule.shutdownTime,
      wakeUpTime: _schedule.wakeUpTime,
      enabled: enabled,
    );
    await _persistence.saveSchedule(_schedule);
  }

  @override
  void startMonitoring() {
    if (_isDisposed) return;
    stopMonitoring();
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _onMonitoringTick(),
    );
  }

  @override
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _delayedShutdownTimer?.cancel();
    _delayedShutdownTimer = null;
  }

  @override
  bool isUserActive(DateTime lastTouchTime) {
    final now = DateTime.now();
    final difference = now.difference(lastTouchTime);
    return difference.inSeconds <= 60;
  }

  @override
  int calculateWakeAlarmEpoch(TimeOfDay wakeTime, DateTime fromDate) {
    // Build a DateTime for the wake time on the same day as fromDate.
    var wakeDateTime = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
      wakeTime.hour,
      wakeTime.minute,
    );

    // If the wake time has already passed today, schedule for tomorrow.
    if (wakeDateTime.isBefore(fromDate) ||
        wakeDateTime.isAtSameMomentAs(fromDate)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    return wakeDateTime.millisecondsSinceEpoch ~/ 1000;
  }

  @override
  Future<void> initiateShutdown() async {
    if (_isDisposed) return;

    // Write the RTC wake alarm if a wake-up time is configured.
    if (_schedule.wakeUpTime != null) {
      final now = DateTime.now();
      final epoch = calculateWakeAlarmEpoch(_schedule.wakeUpTime!, now);

      // Clear the existing alarm first by writing "0".
      await _sysfsWriter.write(kRtcWakeAlarmPath, '0');

      // Write the new wake alarm epoch.
      await _sysfsWriter.write(kRtcWakeAlarmPath, epoch.toString());
    }

    // Initiate system shutdown.
    await _processRunner.run('sudo', ['shutdown', '-h', 'now']);
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopMonitoring();
  }

  /// Called every 60 seconds by the monitoring timer.
  void _onMonitoringTick() {
    if (_isDisposed) return;
    if (!_schedule.enabled) return;
    if (_schedule.shutdownTime == null) return;

    final now = DateTime.now();
    final shutdownTime = _schedule.shutdownTime!;

    // Check if the current time matches the configured shutdown time.
    if (now.hour == shutdownTime.hour && now.minute == shutdownTime.minute) {
      _handleShutdownTimeReached();
    }
  }

  /// Handles the case when the shutdown time is reached.
  void _handleShutdownTimeReached() {
    // Check if the user is actively interacting.
    if (lastTouchTime != null && isUserActive(lastTouchTime!)) {
      // Delay shutdown by 5 minutes.
      _delayedShutdownTimer?.cancel();
      _delayedShutdownTimer = Timer(
        const Duration(minutes: 5),
        () {
          if (!_isDisposed) {
            initiateShutdown();
          }
        },
      );
    } else {
      // No active interaction — initiate shutdown immediately.
      initiateShutdown();
    }
  }

  /// Loads the persisted schedule. Call this during initialization.
  Future<void> loadSchedule() async {
    _schedule = await _persistence.loadSchedule();
  }
}
