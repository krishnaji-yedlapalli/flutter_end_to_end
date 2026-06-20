# Requirements Document

## Introduction

This feature transforms the Flutter application running on a Raspberry Pi 5 with Touch Display 2 into a dedicated kiosk device. The app launches fullscreen without desktop chrome, hides the cursor, sleeps the display after inactivity, wakes on touch, auto-restarts on crash, and provides a hidden 5-tap gesture to exit kiosk mode and return to the normal Raspberry Pi desktop.

All kiosk capabilities are implemented as a core-level service (`lib/core/kiosk/`) that exposes public methods for consumption by any feature module (e.g., daily_tracker or other features that run on the Pi).

## Glossary

- **Kiosk_App**: The Flutter Linux application running in fullscreen kiosk mode on the Raspberry Pi 5
- **Kiosk_Service**: A core-level service class located in `lib/core/kiosk/` that exposes all kiosk-related methods (enter/exit kiosk mode, sleep/wake display, register exit gesture) for consumption by feature modules
- **Touch_Display**: The Raspberry Pi Touch Display 2 connected to the Pi, operating in landscape orientation (1280×720)
- **Kiosk_Mode**: A dedicated device mode where the app runs fullscreen without window decorations, taskbar, or cursor
- **Exit_Gesture**: A 5-tap gesture performed anywhere on the screen within a defined time window to exit kiosk mode
- **Sleep_Mode**: A power-saving state where the display backlight is turned off after a period of inactivity
- **Inactivity_Timer**: A countdown timer that tracks the duration since the last user touch interaction
- **Systemd_Service**: A Linux system service that manages the lifecycle of the Kiosk_App process
- **Backlight_Controller**: A system-level component that controls the Touch_Display backlight via sysfs or vcgencmd

## Requirements

### Requirement 1: Fullscreen Kiosk Launch

**User Story:** As a device owner, I want the app to launch in fullscreen without any desktop UI elements, so that the device behaves as a dedicated appliance.

#### Acceptance Criteria

1. WHEN the Kiosk_App starts, THE Kiosk_App SHALL render in fullscreen mode without window decorations, title bar, or taskbar
2. WHEN the Kiosk_App starts in Kiosk_Mode, THE Kiosk_App SHALL set the window size to match the Touch_Display resolution of 1280×720
3. WHEN the Kiosk_App starts in Kiosk_Mode, THE Kiosk_App SHALL request the window manager to present the window above all other windows

### Requirement 2: Cursor Hiding

**User Story:** As a device user, I want the mouse cursor to be hidden, so that the touch-only interface looks clean and purpose-built.

#### Acceptance Criteria

1. WHEN the Kiosk_App enters Kiosk_Mode, THE Kiosk_App SHALL hide the system mouse cursor
2. WHILE the Kiosk_App is in Kiosk_Mode, THE Kiosk_App SHALL suppress cursor visibility for all pointer events

### Requirement 3: Display Sleep on Inactivity

**User Story:** As a device owner, I want the display to turn off after 10 minutes of no interaction, so that power is conserved and screen burn-in is prevented.

#### Acceptance Criteria

1. WHILE the Kiosk_App is running, THE Inactivity_Timer SHALL reset to 10 minutes on each touch event
2. WHEN the Inactivity_Timer reaches zero, THE Backlight_Controller SHALL turn off the Touch_Display backlight
3. WHILE the Touch_Display backlight is off, THE Kiosk_App SHALL continue running in the background

### Requirement 4: Wake on Touch

**User Story:** As a device user, I want to wake the display by touching the screen, so that I can resume using the app without pressing any buttons.

#### Acceptance Criteria

1. WHEN a touch event occurs while the Touch_Display backlight is off, THE Backlight_Controller SHALL turn on the Touch_Display backlight
2. WHEN the Touch_Display wakes from Sleep_Mode, THE Kiosk_App SHALL discard the first touch event that triggered the wake to prevent unintended interaction
3. WHEN the Touch_Display wakes from Sleep_Mode, THE Inactivity_Timer SHALL reset to 10 minutes

### Requirement 5: Exit Gesture

**User Story:** As a device owner, I want a hidden 5-tap gesture to exit kiosk mode, so that I can access the normal Raspberry Pi desktop when needed.

#### Acceptance Criteria

1. WHEN the user performs 5 taps anywhere on the screen within 3 seconds, THE Kiosk_App SHALL exit Kiosk_Mode
2. WHEN the Exit_Gesture is recognized, THE Kiosk_App SHALL terminate the fullscreen application process
3. WHEN the Kiosk_App terminates via Exit_Gesture, THE Systemd_Service SHALL NOT restart the application
4. IF fewer than 5 taps occur within the 3-second window, THEN THE Kiosk_App SHALL treat the taps as normal touch interactions

### Requirement 6: Auto-Restart on Crash

**User Story:** As a device owner, I want the app to automatically restart if it crashes, so that the kiosk remains operational without manual intervention.

#### Acceptance Criteria

1. WHEN the Kiosk_App process exits with a non-zero exit code, THE Systemd_Service SHALL restart the Kiosk_App within 5 seconds
2. WHEN the Kiosk_App process exits with exit code zero (normal exit via Exit_Gesture), THE Systemd_Service SHALL NOT restart the Kiosk_App
3. IF the Kiosk_App crashes more than 5 times within 60 seconds, THEN THE Systemd_Service SHALL stop attempting restarts and log an error

### Requirement 7: System-Level Auto-Launch on Boot

**User Story:** As a device owner, I want the kiosk app to start automatically when the Raspberry Pi boots, so that the device is ready to use without manual setup.

#### Acceptance Criteria

1. WHEN the Raspberry Pi completes its boot sequence, THE Systemd_Service SHALL start the Kiosk_App automatically
2. WHEN the Systemd_Service starts the Kiosk_App, THE Kiosk_App SHALL launch in Kiosk_Mode with fullscreen and cursor hidden
3. THE Systemd_Service SHALL be configured to start after the graphical display server is available

### Requirement 8: Desktop Environment Suppression

**User Story:** As a device owner, I want the Linux desktop environment to be completely hidden during kiosk operation, so that the device appears as a single-purpose appliance.

#### Acceptance Criteria

1. WHILE the Kiosk_App is in Kiosk_Mode, THE Kiosk_App SHALL suppress system notifications from appearing on screen
2. WHILE the Kiosk_App is in Kiosk_Mode, THE Kiosk_App SHALL prevent desktop elements (taskbar, panels, desktop icons) from being visible behind or around the application window

### Requirement 9: Core Kiosk Service API

**User Story:** As a developer, I want all kiosk functionality exposed as a core-level service with public methods, so that any feature module can consume kiosk capabilities without reimplementing them.

#### Acceptance Criteria

1. THE Kiosk_Service SHALL be located in the `lib/core/kiosk/` directory following the project's core module conventions
2. THE Kiosk_Service SHALL expose a method to enter Kiosk_Mode (fullscreen, hide cursor, start inactivity timer)
3. THE Kiosk_Service SHALL expose a method to exit Kiosk_Mode (restore window, show cursor, stop timers)
4. THE Kiosk_Service SHALL expose a method to manually trigger Sleep_Mode (turn off backlight)
5. THE Kiosk_Service SHALL expose a method to manually trigger wake (turn on backlight)
6. THE Kiosk_Service SHALL expose a method to configure the inactivity timeout duration
7. THE Kiosk_Service SHALL expose a stream or callback for kiosk state changes (entered, exited, sleeping, awake)
8. THE Kiosk_Service SHALL be registered in `get_it` for dependency injection so feature modules can access it
9. THE Kiosk_Service SHALL only activate kiosk behaviors when running on the Linux platform (Raspberry Pi)

### Requirement 10: Scheduled Deep Sleep and Wake-Up

**User Story:** As a device owner, I want to configure scheduled shutdown and wake-up times, so that the Raspberry Pi conserves power during off-hours and automatically resumes operation at a set time.

#### Acceptance Criteria

1. THE Kiosk_Service SHALL expose a method to configure a scheduled shutdown time (hour and minute)
2. THE Kiosk_Service SHALL expose a method to configure a scheduled wake-up time (hour and minute)
3. WHEN the current time reaches the configured shutdown time, THE Kiosk_App SHALL set the RTC wake alarm to the configured wake-up time and initiate a system shutdown
4. WHEN the RTC wake alarm triggers, THE Raspberry Pi SHALL power on and boot the system, and THE Systemd_Service SHALL start the Kiosk_App
5. THE Kiosk_Service SHALL persist the shutdown and wake-up schedule configuration across reboots
6. THE Kiosk_Service SHALL expose a method to enable or disable the scheduled deep sleep feature
7. IF the scheduled shutdown time is reached while the user is actively interacting (touch within the last 60 seconds), THEN THE Kiosk_App SHALL delay the shutdown by 5 minutes and notify the user visually
