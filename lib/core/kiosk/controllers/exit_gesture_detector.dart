/// Exit gesture detector for the kiosk service.
///
/// Recognizes a multi-tap pattern (default: 5 taps in 3 seconds) using a
/// sliding window algorithm over tap timestamps.

/// Interface for exit gesture detection.
///
/// The detector maintains a sliding window of tap timestamps and returns
/// `true` from [recordTap] when the exit gesture pattern is recognized.
abstract class IExitGestureDetector {
  /// Record a tap event. Returns `true` if the exit gesture is recognized.
  ///
  /// The detector:
  /// 1. Removes timestamps older than [timeWindow] from [timestamp]
  /// 2. Adds [timestamp] to the window
  /// 3. Returns `true` if the tap count >= [requiredTaps]
  bool recordTap(DateTime timestamp);

  /// Reset the detector state, clearing all recorded taps.
  void reset();

  /// Number of taps required to trigger the exit gesture (default 5).
  int get requiredTaps;

  /// Duration of the sliding window (default 3 seconds).
  Duration get timeWindow;
}

/// Default implementation of [IExitGestureDetector].
///
/// Uses a list of [DateTime] timestamps as a sliding window. On each
/// [recordTap] call, expired timestamps are pruned before evaluating
/// whether the gesture threshold has been met.
class ExitGestureDetectorImpl implements IExitGestureDetector {
  ExitGestureDetectorImpl({
    int requiredTaps = 5,
    Duration timeWindow = const Duration(seconds: 3),
  })  : _requiredTaps = requiredTaps,
        _timeWindow = timeWindow;

  final int _requiredTaps;
  final Duration _timeWindow;
  final List<DateTime> _tapTimestamps = [];

  @override
  int get requiredTaps => _requiredTaps;

  @override
  Duration get timeWindow => _timeWindow;

  @override
  bool recordTap(DateTime timestamp) {
    // Remove timestamps older than the time window relative to the new tap.
    final cutoff = timestamp.subtract(_timeWindow);
    _tapTimestamps.removeWhere((t) => t.isBefore(cutoff) || t == cutoff);

    // Add the new tap timestamp.
    _tapTimestamps.add(timestamp);

    // Check if the exit gesture threshold is met.
    return _tapTimestamps.length >= _requiredTaps;
  }

  @override
  void reset() {
    _tapTimestamps.clear();
  }
}
