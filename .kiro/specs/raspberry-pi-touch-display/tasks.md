# Implementation Plan: Raspberry Pi Touch Display Kiosk Service

## Overview

This plan implements the Kiosk Service as a core module in `lib/core/kiosk/` following the project's Clean Architecture conventions. The implementation proceeds bottom-up: platform abstractions first, then individual controllers/services, then the facade, then the widget layer, and finally the systemd deployment artifact. Each task builds on the previous, ensuring no orphaned code.

## Tasks

- [x] 1. Set up kiosk module structure and platform abstractions
  - [x] 1.1 Create directory structure and platform abstraction layer
    - Create `lib/core/kiosk/` directory with subdirectories: `controllers/`, `services/`, `platform/`
    - Implement `lib/core/kiosk/platform/linux_process_runner.dart` with `ILinuxProcessRunner` interface and implementation wrapping `Process.run`
    - Implement `lib/core/kiosk/platform/sysfs_writer.dart` with `ISysfsWriter` interface and implementation wrapping `File` I/O for sysfs paths
    - Both implementations must be no-ops on non-Linux platforms (platform guard)
    - _Requirements: 9.1, 9.9_

  - [x] 1.2 Create KioskState and DeepSleepSchedule data models
    - Implement `lib/core/kiosk/kiosk_state.dart` with `KioskMode` enum (`idle`, `active`), `DisplayState` enum (`awake`, `sleeping`), and `KioskState` class with `copyWith`
    - Implement `DeepSleepSchedule` class with `shutdownTime`, `wakeUpTime`, `enabled` fields
    - _Requirements: 9.7, 10.1, 10.2_

  - [ ]* 1.3 Write unit tests for KioskState and DeepSleepSchedule models
    - Test `copyWith` produces correct copies
    - Test default values are correct
    - Test equality semantics
    - _Requirements: 9.7_

- [x] 2. Implement BacklightController
  - [x] 2.1 Implement BacklightController interface and implementation
    - Create `lib/core/kiosk/controllers/backlight_controller.dart`
    - Define `IBacklightController` with `turnOff()`, `turnOn()`, `setBrightness(int)`, `isOn()` methods
    - Implement `BacklightControllerImpl` that writes to `/sys/class/backlight/rpi_backlight/bl_power` via `ISysfsWriter`
    - Implement fallback to `vcgencmd display_power` via `ILinuxProcessRunner` when sysfs path doesn't exist
    - Return no-op results on non-Linux platforms
    - _Requirements: 3.2, 4.1, 9.9_

  - [ ]* 2.2 Write unit tests for BacklightController
    - Test correct sysfs values written for on/off (0 for ON, 1 for OFF)
    - Test fallback to vcgencmd when sysfs path doesn't exist
    - Test no-op behavior on non-Linux platforms
    - Mock `ISysfsWriter` and `ILinuxProcessRunner` using mocktail
    - _Requirements: 3.2, 4.1_

- [x] 3. Implement InactivityTimer
  - [x] 3.1 Implement InactivityTimer interface and implementation
    - Create `lib/core/kiosk/services/inactivity_timer.dart`
    - Define `IInactivityTimer` with `start(Duration)`, `reset()`, `stop()`, `onExpired` stream, `isRunning`, `dispose()`
    - Implement `InactivityTimerImpl` using `Timer` with proper cancellation and restart logic
    - Guard timer callbacks with `_isDisposed` flag
    - _Requirements: 3.1, 3.2, 3.3_

  - [ ]* 3.2 Write property test for inactivity timer reset
    - **Property 1: Inactivity timer resets on touch**
    - Generate random touch event sequences, verify timer resets to full duration after each touch
    - **Validates: Requirements 3.1**

  - [ ]* 3.3 Write property test for timer expiry triggers display sleep
    - **Property 2: Timer expiry triggers display sleep**
    - Generate random timeout durations, verify expiry callback fires exactly once
    - **Validates: Requirements 3.2**

- [x] 4. Implement ExitGestureDetector
  - [x] 4.1 Implement ExitGestureDetector interface and implementation
    - Create `lib/core/kiosk/controllers/exit_gesture_detector.dart`
    - Define `IExitGestureDetector` with `recordTap(DateTime)`, `reset()`, `requiredTaps`, `timeWindow`
    - Implement sliding window algorithm: remove timestamps older than `timeWindow`, add new timestamp, return true if count >= `requiredTaps`
    - Default: 5 taps in 3 seconds
    - _Requirements: 5.1, 5.4_

  - [ ]* 4.2 Write property test for exit gesture recognition
    - **Property 5: Exit gesture recognition**
    - Generate random tap timestamp sequences, verify detector returns true iff >= 5 taps within any 3-second window
    - **Validates: Requirements 5.1, 5.4**

  - [ ]* 4.3 Write unit tests for ExitGestureDetector edge cases
    - Test exactly 5 taps in 3s triggers exit
    - Test 4 taps in 3s does NOT trigger
    - Test 5 taps spread over >3s does NOT trigger
    - Test reset clears state
    - _Requirements: 5.1, 5.4_

- [x] 5. Implement WindowManager
  - [x] 5.1 Implement WindowManager interface and implementation
    - Create `lib/core/kiosk/controllers/window_manager.dart`
    - Define `IWindowManager` with `enterFullscreen()`, `exitFullscreen()`, `hideCursor()`, `showCursor()`, `setAlwaysOnTop(bool)`, `setSize(int, int)`
    - Implement using `ILinuxProcessRunner` to invoke `xdotool` or `wmctrl` commands
    - No-op on non-Linux platforms
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2_

  - [ ]* 5.2 Write unit tests for WindowManager
    - Test correct commands are invoked for fullscreen/restore
    - Test cursor hide/show commands
    - Test no-op on non-Linux
    - Mock `ILinuxProcessRunner`
    - _Requirements: 1.1, 2.1_

- [x] 6. Checkpoint - Core controllers complete
  - Ensure all tests pass, ask the user if questions arise.

- [x] 7. Implement SchedulePersistence and DeepSleepScheduler
  - [x] 7.1 Implement SchedulePersistence
    - Create `lib/core/kiosk/services/schedule_persistence.dart`
    - Define `ISchedulePersistence` with `saveSchedule(DeepSleepSchedule)` and `loadSchedule()` methods
    - Implement using `shared_preferences` with JSON serialization under key `kiosk_deep_sleep_schedule`
    - Handle read/write failures gracefully (return defaults, log warning)
    - _Requirements: 10.5_

  - [ ]* 7.2 Write property test for schedule persistence round-trip
    - **Property 7: Schedule persistence round-trip**
    - Generate random valid schedules (hour 0-23, minute 0-59, enabled boolean), verify save then load produces identical schedule
    - **Validates: Requirements 10.5**

  - [x] 7.3 Implement DeepSleepScheduler
    - Create `lib/core/kiosk/services/deep_sleep_scheduler.dart`
    - Define `IDeepSleepScheduler` with `setShutdownTime`, `setWakeUpTime`, `setEnabled`, `schedule`, `startMonitoring`, `stopMonitoring`, `isUserActive`, `calculateWakeAlarmEpoch`, `initiateShutdown`, `dispose`
    - Implement periodic monitoring (check every 60s if current time matches shutdown time)
    - Implement active interaction check (touch within last 60s delays shutdown by 5 minutes)
    - Implement RTC wake alarm write to `/sys/class/rtc/rtc0/wakealarm` via `ISysfsWriter`
    - Implement system shutdown via `ILinuxProcessRunner` calling `sudo shutdown -h now`
    - _Requirements: 10.1, 10.2, 10.3, 10.6, 10.7_

  - [ ]* 7.4 Write property test for active interaction delays shutdown
    - **Property 8: Active interaction delays shutdown**
    - Generate random timing scenarios with last-touch within 60s of shutdown time, verify shutdown is delayed by 5 minutes
    - **Validates: Requirements 10.7**

  - [ ]* 7.5 Write property test for RTC wake alarm calculation
    - **Property 9: RTC wake alarm calculation**
    - Generate random wake-up times and reference dates, verify calculated epoch corresponds to next occurrence of that time-of-day
    - **Validates: Requirements 10.3**

- [x] 8. Implement KioskService facade
  - [x] 8.1 Create IKioskService interface
    - Create `lib/core/kiosk/kiosk_service.dart`
    - Define `IKioskService` abstract class with all public methods: `stateStream`, `currentState`, `enterKioskMode()`, `exitKioskMode()`, `sleepDisplay()`, `wakeDisplay()`, `setInactivityTimeout()`, `setShutdownTime()`, `setWakeUpTime()`, `setDeepSleepEnabled()`, `schedule`, `onTouchEvent()`, `dispose()`
    - _Requirements: 9.2, 9.3, 9.4, 9.5, 9.6, 9.7_

  - [x] 8.2 Implement KioskServiceImpl facade
    - Create `lib/core/kiosk/kiosk_service_impl.dart`
    - Inject all sub-components: `IBacklightController`, `IInactivityTimer`, `IExitGestureDetector`, `IDeepSleepScheduler`, `IWindowManager`
    - Implement `enterKioskMode()`: call windowManager.enterFullscreen(), hideCursor(), setAlwaysOnTop(true), start inactivity timer, start deep sleep monitoring, emit active state
    - Implement `exitKioskMode()`: restore window, show cursor, stop timers, call `exit(0)` for clean systemd exit
    - Implement `sleepDisplay()` / `wakeDisplay()`: delegate to backlight controller, update state
    - Implement `onTouchEvent()`: reset inactivity timer, check exit gesture, if display sleeping then wake and consume event
    - Implement state stream via `StreamController<KioskState>.broadcast()` with synchronous updates
    - Platform guard: if not Linux, all methods resolve immediately with idle state
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 3.1, 3.2, 4.1, 4.2, 5.1, 5.2, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.9_

  - [ ]* 8.3 Write property test for touch wakes sleeping display
    - **Property 3: Touch wakes sleeping display**
    - Generate random kiosk states where display is sleeping, verify touch triggers backlight on and state transitions to awake
    - **Validates: Requirements 4.1**

  - [ ]* 8.4 Write property test for wake touch consumption
    - **Property 4: Wake touch is consumed**
    - Generate touch events during sleep state, verify the event is not forwarded to the application gesture system
    - **Validates: Requirements 4.2**

  - [ ]* 8.5 Write property test for kiosk state stream correctness
    - **Property 6: Kiosk state stream correctness**
    - Generate random operation sequences (enter, exit, sleep, wake), verify stream emits exactly one state change per operation with correct state
    - **Validates: Requirements 9.7**

- [x] 9. Checkpoint - Facade and services complete
  - Ensure all tests pass, ask the user if questions arise.

- [x] 10. Implement DI module and gesture wrapper widget
  - [x] 10.1 Implement KioskInjectionModule
    - Create `lib/core/kiosk/kiosk_injection_module.dart`
    - Register all kiosk dependencies in `get_it` as lazy singletons: `ISysfsWriter`, `ILinuxProcessRunner`, `IBacklightController`, `IInactivityTimer`, `IExitGestureDetector`, `ISchedulePersistence`, `IDeepSleepScheduler`, `IWindowManager`, `IKioskService`
    - Follow existing project DI patterns (singleton module with `registerDependencies()` method)
    - _Requirements: 9.8_

  - [x] 10.2 Implement KioskGestureWrapper widget
    - Create `lib/core/kiosk/kiosk_gesture_wrapper.dart`
    - Use `Listener` widget (not `GestureDetector`) to capture all `PointerDownEvent`s without interfering with child gesture recognizers
    - Forward touch events to `IKioskService.onTouchEvent()`
    - When display is sleeping, consume the first touch (return without passing to child) and wake the display
    - Check exit gesture result from `onTouchEvent()` and handle exit if recognized
    - _Requirements: 3.1, 4.1, 4.2, 5.1_

  - [ ]* 10.3 Write unit tests for KioskGestureWrapper
    - Test that touch events are forwarded to KioskService
    - Test that wake touch is consumed (not passed to child)
    - Test that normal touches pass through to child widgets
    - Mock `IKioskService` using mocktail
    - _Requirements: 4.2, 5.1_

- [x] 11. Wire kiosk module into the application
  - [x] 11.1 Integrate KioskInjectionModule into app startup
    - Call `KioskInjectionModule().registerDependencies()` in `main.dart` during initialization (before `runApp`)
    - Wrap the app's root widget tree with `KioskGestureWrapper` (inside `MyApp` build method, wrapping the `MaterialApp.router`)
    - Call `kioskService.enterKioskMode()` after app initialization on Linux platform
    - _Requirements: 7.2, 8.1, 8.2, 9.1, 9.8_

  - [ ]* 11.2 Write integration test for kiosk mode lifecycle
    - Test enter kiosk mode → verify state is active
    - Test inactivity → verify display sleeps
    - Test touch during sleep → verify wake
    - Test exit gesture → verify exit triggered
    - Use mocked sub-components to run on any platform
    - _Requirements: 9.2, 9.3, 9.4, 9.5_

- [x] 12. Create systemd service file and setup script
  - [x] 12.1 Create systemd service file and permissions setup script
    - Create `scripts/kiosk-app.service` with `Restart=on-failure`, `RestartSec=5`, `StartLimitBurst=5`, `StartLimitIntervalSec=60`, `After=graphical.target`
    - Create `scripts/setup_kiosk_permissions.sh` that configures udev rules for backlight and RTC access, sudoers entry for shutdown
    - Include installation instructions as comments in the script
    - _Requirements: 6.1, 6.2, 6.3, 7.1, 7.3_

- [x] 13. Final checkpoint - Full implementation complete
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- All system interactions are abstracted behind interfaces, enabling tests to run on any platform (macOS, CI) without a Raspberry Pi
- The `fast_check` package will need to be added to `dev_dependencies` for property-based tests
- Platform guards ensure the entire module is safe to import and call on non-Linux platforms

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2"] },
    { "id": 1, "tasks": ["1.3", "2.1", "4.1", "5.1"] },
    { "id": 2, "tasks": ["2.2", "3.1", "4.2", "4.3", "5.2"] },
    { "id": 3, "tasks": ["3.2", "3.3", "7.1"] },
    { "id": 4, "tasks": ["7.2", "7.3"] },
    { "id": 5, "tasks": ["7.4", "7.5", "8.1"] },
    { "id": 6, "tasks": ["8.2"] },
    { "id": 7, "tasks": ["8.3", "8.4", "8.5", "10.1"] },
    { "id": 8, "tasks": ["10.2", "10.3"] },
    { "id": 9, "tasks": ["11.1", "12.1"] },
    { "id": 10, "tasks": ["11.2"] }
  ]
}
```
