import 'dart:async';

/// Abstraction over an inactivity countdown timer.
///
/// The timer starts with a configured [Duration] and emits on [onExpired]
/// when the countdown reaches zero. Calling [reset] restarts the countdown
/// from the full duration. Calling [stop] cancels the countdown without
/// emitting.
///
/// Used by the Kiosk Service to detect user inactivity and trigger
/// display sleep after a configurable timeout period.
abstract class IInactivityTimer {
  /// Start the timer with the configured duration.
  void start(Duration duration);

  /// Reset the timer (restarts countdown from full duration).
  void reset();

  /// Stop the timer without emitting an expiry event.
  void stop();

  /// Stream that emits when the timer expires.
  Stream<void> get onExpired;

  /// Whether the timer is currently running.
  bool get isRunning;

  /// Dispose all resources. After disposal, the timer cannot be reused.
  void dispose();
}

/// Implementation of [IInactivityTimer] using [Timer] from `dart:async`.
///
/// Uses a [StreamController.broadcast] for the [onExpired] stream so that
/// multiple listeners can subscribe. All timer callbacks are guarded with
/// an [_isDisposed] flag to prevent callbacks firing after disposal.
class InactivityTimerImpl implements IInactivityTimer {
  Timer? _timer;
  Duration? _duration;
  bool _isDisposed = false;

  final StreamController<void> _expiredController =
      StreamController<void>.broadcast();

  @override
  Stream<void> get onExpired => _expiredController.stream;

  @override
  bool get isRunning => _timer?.isActive ?? false;

  @override
  void start(Duration duration) {
    if (_isDisposed) return;

    _duration = duration;
    _cancelTimer();
    _timer = Timer(duration, _onTimerExpired);
  }

  @override
  void reset() {
    if (_isDisposed) return;
    if (_duration == null) return;

    _cancelTimer();
    _timer = Timer(_duration!, _onTimerExpired);
  }

  @override
  void stop() {
    if (_isDisposed) return;

    _cancelTimer();
  }

  @override
  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;
    _cancelTimer();
    _expiredController.close();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimerExpired() {
    if (_isDisposed) return;

    _expiredController.add(null);
  }
}
