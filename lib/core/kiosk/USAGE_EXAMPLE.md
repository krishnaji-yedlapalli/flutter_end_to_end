# Kiosk Service - Usage Examples

## Basic Consumption from a Feature Module

Any feature module can access the Kiosk Service via `get_it`:

```dart
import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/kiosk/kiosk_service.dart';
import 'package:sample_latest/core/kiosk/kiosk_state.dart';

class MyFeaturePage extends StatefulWidget {
  @override
  State<MyFeaturePage> createState() => _MyFeaturePageState();
}

class _MyFeaturePageState extends State<MyFeaturePage> {
  final IKioskService _kioskService = GetIt.instance<IKioskService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KioskState>(
      stream: _kioskService.stateStream,
      initialData: _kioskService.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data!;

        return Column(
          children: [
            Text('Kiosk Mode: ${state.mode}'),
            Text('Display: ${state.displayState}'),
            Text('Deep Sleep: ${state.deepSleepEnabled ? "ON" : "OFF"}'),
          ],
        );
      },
    );
  }
}
```

## Manually Controlling Display Sleep/Wake

```dart
final kioskService = GetIt.instance<IKioskService>();

// Put display to sleep manually (e.g., from a "screen off" button)
await kioskService.sleepDisplay();

// Wake the display manually
await kioskService.wakeDisplay();
```

## Configuring Inactivity Timeout

```dart
final kioskService = GetIt.instance<IKioskService>();

// Change timeout to 5 minutes instead of the default 10
kioskService.setInactivityTimeout(const Duration(minutes: 5));
```

## Configuring Scheduled Deep Sleep

```dart
import 'package:flutter/material.dart';

final kioskService = GetIt.instance<IKioskService>();

// Set shutdown at 10:00 PM
await kioskService.setShutdownTime(const TimeOfDay(hour: 22, minute: 0));

// Set wake-up at 7:00 AM
await kioskService.setWakeUpTime(const TimeOfDay(hour: 7, minute: 0));

// Enable the schedule
await kioskService.setDeepSleepEnabled(true);

// Read current schedule
final schedule = kioskService.schedule;
print('Shutdown: ${schedule.shutdownTime}');
print('Wake-up: ${schedule.wakeUpTime}');
print('Enabled: ${schedule.enabled}');
```

## Using with a Cubit (BLoC Pattern)

```dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/kiosk/kiosk_service.dart';
import 'package:sample_latest/core/kiosk/kiosk_state.dart';

class KioskSettingsCubit extends Cubit<KioskState> {
  KioskSettingsCubit()
      : _kioskService = GetIt.instance<IKioskService>(),
        super(GetIt.instance<IKioskService>().currentState) {
    _subscription = _kioskService.stateStream.listen(emit);
  }

  final IKioskService _kioskService;
  late final StreamSubscription<KioskState> _subscription;

  Future<void> updateInactivityTimeout(Duration duration) async {
    _kioskService.setInactivityTimeout(duration);
  }

  Future<void> configureDeepSleep({
    TimeOfDay? shutdownTime,
    TimeOfDay? wakeUpTime,
    bool? enabled,
  }) async {
    if (shutdownTime != null) {
      await _kioskService.setShutdownTime(shutdownTime);
    }
    if (wakeUpTime != null) {
      await _kioskService.setWakeUpTime(wakeUpTime);
    }
    if (enabled != null) {
      await _kioskService.setDeepSleepEnabled(enabled);
    }
  }

  Future<void> toggleDisplay() async {
    if (state.displayState == DisplayState.sleeping) {
      await _kioskService.wakeDisplay();
    } else {
      await _kioskService.sleepDisplay();
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
```

## Listening to State Changes for UI Updates

```dart
// Show a "display sleeping" overlay when the screen is off
StreamBuilder<KioskState>(
  stream: GetIt.instance<IKioskService>().stateStream,
  builder: (context, snapshot) {
    final isSleeping =
        snapshot.data?.displayState == DisplayState.sleeping;

    if (isSleeping) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Text(
            'Touch to wake',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return const SizedBox.shrink(); // Normal UI visible
  },
)
```

## Platform Safety

The Kiosk Service is safe to call on any platform. On non-Linux (iOS, Android, web, macOS, Windows), all methods are no-ops:

```dart
// This is safe to call unconditionally — no platform checks needed
final kioskService = GetIt.instance<IKioskService>();
await kioskService.enterKioskMode(); // No-op on non-Linux
await kioskService.sleepDisplay();   // No-op on non-Linux
```

## Architecture Summary

```
Feature Module (e.g., daily_tracker)
    │
    ▼
GetIt.instance<IKioskService>()   ← Dependency Injection
    │
    ▼
KioskServiceImpl (facade)         ← Orchestrates everything
    │
    ├── BacklightController       ← Display on/off via sysfs
    ├── InactivityTimer           ← 10-min countdown
    ├── ExitGestureDetector       ← 5-tap-in-3s detection
    ├── DeepSleepScheduler        ← Scheduled shutdown/wake
    └── WindowManager             ← Fullscreen, cursor, always-on-top
```
