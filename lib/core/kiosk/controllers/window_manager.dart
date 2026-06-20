import 'package:sample_latest/core/kiosk/platform/linux_process_runner.dart';

/// Abstraction for window management operations in kiosk mode.
///
/// Provides methods to control fullscreen state, cursor visibility,
/// window stacking order, and window size. On non-Linux platforms,
/// all operations are safe no-ops (handled by [ILinuxProcessRunner]).
abstract class IWindowManager {
  /// Set fullscreen mode without decorations.
  Future<void> enterFullscreen();

  /// Restore normal windowed mode.
  Future<void> exitFullscreen();

  /// Hide the mouse cursor.
  Future<void> hideCursor();

  /// Show the mouse cursor.
  Future<void> showCursor();

  /// Set window always on top.
  Future<void> setAlwaysOnTop(bool value);

  /// Set window size.
  Future<void> setSize(int width, int height);
}

/// Linux implementation of [IWindowManager] that uses `xdotool` for
/// fullscreen/cursor operations and `wmctrl` for always-on-top.
///
/// All process invocations go through [ILinuxProcessRunner], which returns
/// no-op results on non-Linux platforms.
class WindowManagerImpl implements IWindowManager {
  final ILinuxProcessRunner _processRunner;

  /// Whether the cursor is currently hidden.
  bool _cursorHidden = false;

  WindowManagerImpl({required ILinuxProcessRunner processRunner})
      : _processRunner = processRunner;

  @override
  Future<void> enterFullscreen() async {
    // Use xdotool to set the active window to fullscreen.
    await _processRunner.run(
      'xdotool',
      ['getactivewindow', 'windowstate', '--add', 'FULLSCREEN'],
    );
  }

  @override
  Future<void> exitFullscreen() async {
    // Use xdotool to remove fullscreen state from the active window.
    await _processRunner.run(
      'xdotool',
      ['getactivewindow', 'windowstate', '--remove', 'FULLSCREEN'],
    );
  }

  @override
  Future<void> hideCursor() async {
    // Use xdotool to move cursor off-screen and unclutter to keep it hidden.
    await _processRunner.run(
      'unclutter',
      ['-idle', '0', '-root'],
      runInShell: true,
    );
    _cursorHidden = true;
  }

  @override
  Future<void> showCursor() async {
    if (_cursorHidden) {
      // Kill unclutter processes to restore cursor visibility.
      await _processRunner.run('killall', ['unclutter']);
      _cursorHidden = false;
    }
  }

  @override
  Future<void> setAlwaysOnTop(bool value) async {
    // Use wmctrl for always-on-top window property.
    final action = value ? 'add' : 'remove';
    await _processRunner.run(
      'wmctrl',
      ['-r', ':ACTIVE:', '-b', '$action,above'],
    );
  }

  @override
  Future<void> setSize(int width, int height) async {
    // Use xdotool to resize the active window.
    await _processRunner.run(
      'xdotool',
      ['getactivewindow', 'windowsize', '$width', '$height'],
    );
  }
}
