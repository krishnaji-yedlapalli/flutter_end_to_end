import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sample_latest/core/kiosk/platform/linux_process_runner.dart';
import 'package:sample_latest/core/kiosk/platform/sysfs_writer.dart';

/// Abstraction over the Raspberry Pi Touch Display backlight control.
///
/// Provides methods to turn the backlight on/off, set brightness, and
/// query the current power state. Implementations use sysfs as the primary
/// mechanism and fall back to `vcgencmd` when the sysfs path is unavailable.
abstract class IBacklightController {
  /// Turn off the display backlight (bl_power = 1).
  ///
  /// Returns `true` if the operation succeeded, `false` otherwise.
  Future<bool> turnOff();

  /// Turn on the display backlight (bl_power = 0).
  ///
  /// Returns `true` if the operation succeeded, `false` otherwise.
  Future<bool> turnOn();

  /// Set brightness level (0-255).
  ///
  /// Returns `true` if the operation succeeded, `false` otherwise.
  Future<bool> setBrightness(int value);

  /// Read current backlight power state.
  ///
  /// Returns `true` if the backlight is currently on, `false` otherwise.
  Future<bool> isOn();
}

/// Linux implementation of [IBacklightController].
///
/// Primary path: writes to `/sys/class/backlight/rpi_backlight/bl_power`
/// where `0` = backlight ON and `1` = backlight OFF.
///
/// Fallback: if the sysfs path doesn't exist, uses `vcgencmd display_power`
/// via [ILinuxProcessRunner].
///
/// On non-Linux platforms, all methods return safe no-op results.
class BacklightControllerImpl implements IBacklightController {
  BacklightControllerImpl({
    required ISysfsWriter sysfsWriter,
    required ILinuxProcessRunner processRunner,
  })  : _sysfsWriter = sysfsWriter,
        _processRunner = processRunner;

  final ISysfsWriter _sysfsWriter;
  final ILinuxProcessRunner _processRunner;

  bool get _isLinux => !kIsWeb && Platform.isLinux;

  static const String _blPowerPath =
      '/sys/class/backlight/rpi_backlight/bl_power';
  static const String _brightnessPath =
      '/sys/class/backlight/rpi_backlight/brightness';

  @override
  Future<bool> turnOff() async {
    if (!_isLinux) return false;

    // Try sysfs first
    if (await _sysfsWriter.exists(_blPowerPath)) {
      return _sysfsWriter.write(_blPowerPath, '1');
    }

    // Fallback to vcgencmd
    final result = await _processRunner.run('vcgencmd', ['display_power', '0']);
    return result.exitCode == 0;
  }

  @override
  Future<bool> turnOn() async {
    if (!_isLinux) return false;

    // Try sysfs first
    if (await _sysfsWriter.exists(_blPowerPath)) {
      return _sysfsWriter.write(_blPowerPath, '0');
    }

    // Fallback to vcgencmd
    final result = await _processRunner.run('vcgencmd', ['display_power', '1']);
    return result.exitCode == 0;
  }

  @override
  Future<bool> setBrightness(int value) async {
    if (!_isLinux) return false;

    final clamped = value.clamp(0, 255);

    if (await _sysfsWriter.exists(_brightnessPath)) {
      return _sysfsWriter.write(_brightnessPath, '$clamped');
    }

    // No vcgencmd fallback for brightness — only sysfs supports it
    return false;
  }

  @override
  Future<bool> isOn() async {
    if (!_isLinux) return false;

    if (await _sysfsWriter.exists(_blPowerPath)) {
      final content = await _sysfsWriter.read(_blPowerPath);
      if (content == null) return false;
      // bl_power: 0 = ON, 1 = OFF
      return content.trim() == '0';
    }

    // Fallback: query vcgencmd display_power (no argument returns current state)
    final result = await _processRunner.run('vcgencmd', ['display_power']);
    if (result.exitCode != 0) return false;
    // vcgencmd output format: "display_power=1" (1 = on, 0 = off)
    final stdout = result.stdout.toString().trim();
    return stdout.contains('display_power=1');
  }
}
