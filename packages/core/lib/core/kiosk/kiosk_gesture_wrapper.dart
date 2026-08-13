import 'package:app_core/core/kiosk/kiosk_service.dart';
import 'package:app_core/core/kiosk/kiosk_state.dart';
import 'package:flutter/material.dart';

/// A widget that wraps the app's root to intercept all touch events for the
/// kiosk service.
///
/// Uses a [Listener] widget (not [GestureDetector]) to capture all
/// [PointerDownEvent]s without interfering with child gesture recognizers.
///
/// Forwards touch events to [IKioskService.onTouchEvent()] for:
/// - Inactivity timer reset
/// - Exit gesture detection (5 taps in 3 seconds)
/// - Display wake on touch when sleeping
///
/// When the display is sleeping, the child is wrapped with [AbsorbPointer]
/// so that the wake touch does not propagate to the underlying UI.
class KioskGestureWrapper extends StatelessWidget {
  const KioskGestureWrapper({
    super.key,
    required this.child,
    required this.kioskService,
  });

  /// The child widget tree (typically the app's MaterialApp).
  final Widget child;

  /// The kiosk service instance to forward touch events to.
  final IKioskService kioskService;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      child: StreamBuilder<KioskState>(
        stream: kioskService.stateStream,
        initialData: kioskService.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data ?? kioskService.currentState;
          final isSleeping = state.displayState == DisplayState.sleeping;

          // When the display is sleeping, wrap the child with AbsorbPointer
          // to prevent the wake touch from reaching the UI.
          if (isSleeping) {
            return AbsorbPointer(child: child);
          }

          return child;
        },
      ),
    );
  }

  /// Handles all pointer-down events by forwarding them to the kiosk service.
  ///
  /// The [Listener] widget captures events at the top level without
  /// participating in the gesture arena, so it does not interfere with
  /// child gesture recognizers.
  void _onPointerDown(PointerDownEvent event) {
    kioskService.onTouchEvent();
  }
}
