import 'dart:io';

import 'package:flutter/foundation.dart';

/// Abstraction over [File] I/O for sysfs paths.
///
/// All sysfs read/write operations in the kiosk module go through this
/// interface, allowing tests to mock file system interactions without
/// requiring actual sysfs paths (which only exist on Linux/Raspberry Pi).
abstract class ISysfsWriter {
  /// Writes [value] to the sysfs file at [path].
  ///
  /// Returns `true` if the write succeeded, `false` otherwise.
  /// On non-Linux platforms, returns `false` as a no-op.
  Future<bool> write(String path, String value);

  /// Reads the content of the sysfs file at [path].
  ///
  /// Returns the trimmed file content, or `null` if the read failed.
  /// On non-Linux platforms, returns `null` as a no-op.
  Future<String?> read(String path);

  /// Checks whether the sysfs file at [path] exists.
  ///
  /// On non-Linux platforms, returns `false`.
  Future<bool> exists(String path);
}

/// Linux implementation of [ISysfsWriter] that delegates to [File] I/O.
///
/// On non-Linux platforms, all calls are safe no-ops.
class SysfsWriterImpl implements ISysfsWriter {
  @override
  Future<bool> write(String path, String value) async {
    if (kIsWeb || !Platform.isLinux) {
      return false;
    }

    try {
      final file = File(path);
      await file.writeAsString(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> read(String path) async {
    if (kIsWeb || !Platform.isLinux) {
      return null;
    }

    try {
      final file = File(path);
      final content = await file.readAsString();
      return content.trim();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> exists(String path) async {
    if (kIsWeb || !Platform.isLinux) {
      return false;
    }

    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }
}
