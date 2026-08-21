# App Update Feature

Smart app update checks with OS compatibility and version comparison using Firebase Remote Config.

## Overview

Most apps simply compare the installed app version with the latest version available on the store. This feature demonstrates a more comprehensive approach:

1. **OS Compatibility Check** — Is the user's OS version still supported?
2. **Force Update Check** — Is the app version below the minimum supported version?
3. **Flexible Update Check** — Is there a newer version available (but not mandatory)?

## Update Flow

```
OS version < min_supported_os? → Block Screen (non-dismissible)
  ↓ (pass)
App version < min_supported_app_version? → Force Update Screen (non-dismissible)
  ↓ (pass)
App version < latest_app_version? → Flexible Update Dialog (dismissible)
  ↓ (pass)
Proceed to app normally
```

## Remote Config Keys

| Key | Type | Example | Description |
|-----|------|---------|-------------|
| `min_supported_sdk_version_android` | String | `"34"` | Minimum Android SDK (API level) supported |
| `min_supported_os_version_ios` | String | `"17.0"` | Minimum iOS version supported |
| `min_supported_os_version_macos` | String | `"13.0"` | Minimum macOS version supported |
| `min_supported_os_version_web` | String | `"120"` | Minimum browser major version supported |
| `min_supported_app_version` | String | `"1.5.0"` | Versions below this require force update |
| `latest_app_version` | String | `"2.1.0"` | Latest available app version |
| `app_update_url` | String | `"https://example.com/update"` | URL opened by the Update button |

> **Note:** Android uses SDK (API) level for comparison, not the Android version string. For example, Android 14 = SDK 34.

## OS Version Detection

OS version detection uses `device_info_plus` for accurate, platform-native values:

| Platform | Source | Example value |
|---|---|---|
| Android | `androidInfo.version.sdkInt` | `34` |
| iOS | `iosInfo.systemVersion` | `17.4` |
| macOS | `iosInfo.systemVersion` | `14.0` |
| Web | Browser major version parsed from user agent | `120` |

All values are returned as `Future<num>` and compared numerically. Any parsing failure returns `0` (safe fallback — no false blocks).

## Architecture

```
lib/
├── core/
│   ├── app_update_injection_module.dart    # GetIt dependency registration
│   └── app_update_startup_check.dart       # Startup check entry point
├── data/
│   ├── repository/
│   │   └── app_update_repository_impl.dart # Repository implementation
│   └── utils/
│       ├── version_comparator.dart         # Semantic version comparison
│       └── os_version_parser.dart          # Platform OS version parsing via device_info_plus
├── domain/
│   ├── entities/
│   │   └── app_update_result.dart          # Entity + status enum
│   ├── repository/
│   │   └── app_update_repository.dart      # Abstract repository contract
│   └── use_cases/
│       └── check_app_update_use_case.dart  # Use case
└── presentation/
    ├── constants/
    │   └── app_update_demo_constants.dart  # Dropdown option lists
    ├── cubit/
    │   ├── app_update_cubit.dart           # State management
    │   └── app_update_state.dart           # States
    ├── pages/
    │   └── app_update_demo_page.dart       # Demo panel with dropdowns
    └── screens/
        ├── os_blocked_screen.dart          # OS unsupported (non-dismissible)
        ├── force_update_screen.dart        # Force update (non-dismissible)
        └── flexible_update_dialog.dart     # Flexible update (dismissible)
```

## How to Demo

1. Navigate to **App Update** from the home screen grid
2. View the **Current Device Info** card — shows real platform, OS version, and app version (read-only, not used in simulation)
3. View the **Remote Config Thresholds** card — shows the values fetched from Firebase Remote Config that the simulation runs against
4. Use the **Simulate Update Check** section:
   - Select any OS version (1–200) from the dropdown
   - Select an App version from the dropdown
   - Tap **Execute** to see the corresponding result screen

### Example Scenarios (assuming Remote Config defaults):

| OS Version | App Version | Expected Result |
|---|---|---|
| `15` | `1.0.0` | Force Update Screen |
| `10` | `2.1.0` | OS Blocked Screen |
| `15` | `2.0.0` | Flexible Update Dialog |
| `15` | `2.1.0` | Up to Date (SnackBar) |

## Startup Behavior

On app launch, the update check runs automatically via `AppUpdateStartupCheck.performCheck()`, called from the home screen's `initState` post-frame callback. If the Remote Config values indicate an update is needed, the appropriate screen or dialog is shown before the user can interact with the app.

Force update and OS blocked screens use `PopScope(canPop: false)` to prevent back navigation, making them truly non-dismissible.

## Dependencies

- `app_core` — Firebase Remote Config service
- `device_info_plus` — Accurate OS and browser version detection
- `package_info_plus` — Reading current app version
- `flutter_bloc` — Cubit state management
- `get_it` — Dependency injection
- `url_launcher` — Opening the update URL
- `equatable` — Value equality for entities and states
