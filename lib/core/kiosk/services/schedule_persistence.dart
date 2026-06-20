import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_latest/core/kiosk/kiosk_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to store the deep sleep schedule in shared preferences.
const String _kScheduleKey = 'kiosk_deep_sleep_schedule';

/// Interface for persisting and loading the deep sleep schedule.
abstract class ISchedulePersistence {
  /// Saves the given [schedule] to persistent storage.
  Future<void> saveSchedule(DeepSleepSchedule schedule);

  /// Loads the persisted schedule, or returns a default if none exists or on failure.
  Future<DeepSleepSchedule> loadSchedule();
}

/// Implementation of [ISchedulePersistence] using [SharedPreferences] with JSON serialization.
class SchedulePersistenceImpl implements ISchedulePersistence {
  @override
  Future<void> saveSchedule(DeepSleepSchedule schedule) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = _scheduleToJson(schedule);
      final encoded = jsonEncode(json);
      await prefs.setString(_kScheduleKey, encoded);
    } catch (e) {
      debugPrint('Warning: Failed to save deep sleep schedule: $e');
    }
  }

  @override
  Future<DeepSleepSchedule> loadSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_kScheduleKey);
      if (encoded == null) {
        return const DeepSleepSchedule();
      }
      final json = jsonDecode(encoded) as Map<String, dynamic>;
      return _scheduleFromJson(json);
    } catch (e) {
      debugPrint('Warning: Failed to load deep sleep schedule: $e');
      return const DeepSleepSchedule();
    }
  }

  /// Converts a [DeepSleepSchedule] to a JSON-compatible map.
  Map<String, dynamic> _scheduleToJson(DeepSleepSchedule schedule) {
    return {
      if (schedule.shutdownTime != null)
        'shutdownHour': schedule.shutdownTime!.hour,
      if (schedule.shutdownTime != null)
        'shutdownMinute': schedule.shutdownTime!.minute,
      if (schedule.wakeUpTime != null) 'wakeUpHour': schedule.wakeUpTime!.hour,
      if (schedule.wakeUpTime != null)
        'wakeUpMinute': schedule.wakeUpTime!.minute,
      'enabled': schedule.enabled,
    };
  }

  /// Constructs a [DeepSleepSchedule] from a JSON map.
  DeepSleepSchedule _scheduleFromJson(Map<String, dynamic> json) {
    final shutdownHour = json['shutdownHour'] as int?;
    final shutdownMinute = json['shutdownMinute'] as int?;
    final wakeUpHour = json['wakeUpHour'] as int?;
    final wakeUpMinute = json['wakeUpMinute'] as int?;
    final enabled = json['enabled'] as bool? ?? false;

    return DeepSleepSchedule(
      shutdownTime: shutdownHour != null && shutdownMinute != null
          ? TimeOfDay(hour: shutdownHour, minute: shutdownMinute)
          : null,
      wakeUpTime: wakeUpHour != null && wakeUpMinute != null
          ? TimeOfDay(hour: wakeUpHour, minute: wakeUpMinute)
          : null,
      enabled: enabled,
    );
  }
}
