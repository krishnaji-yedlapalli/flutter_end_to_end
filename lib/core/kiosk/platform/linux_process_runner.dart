import 'dart:io';

import 'package:flutter/foundation.dart';

/// Abstraction over [Process.run] for testability.
///
/// All system process invocations in the kiosk module go through this
/// interface, allowing tests to mock process execution without requiring
/// a Linux environment.
abstract class ILinuxProcessRunner {
  /// Runs a system process with the given [executable] and [arguments].
  ///
  /// Returns a [ProcessResult] with stdout, stderr, and exit code.
  /// On non-Linux platforms, returns a no-op result with exit code -1.
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    bool runInShell = false,
  });
}

/// Linux implementation of [ILinuxProcessRunner] that delegates to [Process.run].
///
/// On non-Linux platforms, all calls are safe no-ops returning exit code -1.
class LinuxProcessRunnerImpl implements ILinuxProcessRunner {
  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    bool runInShell = false,
  }) async {
    if (kIsWeb || !Platform.isLinux) {
      return ProcessResult(0, -1, '', 'Not running on Linux');
    }

    return Process.run(executable, arguments, runInShell: runInShell);
  }
}
