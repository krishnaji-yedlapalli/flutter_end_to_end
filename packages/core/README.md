# app_core

Core infrastructure package shared by all feature modules in the Flutter End to End monorepo.

## Overview

`app_core` provides the foundational services, utilities, and configurations that every feature module depends on. It consolidates analytics/error handling, database infrastructure, routing, theming, IoT/kiosk controllers, connectivity management, and localization into a single shared package so that features remain focused on their domain logic.

## Package Structure

```
packages/core/
├── lib/
│   ├── analytics_exception_handler/   # Error reporting & analytics
│   │   ├── analytics_logging.dart
│   │   ├── custom_exception.dart
│   │   ├── error_reporting.dart
│   │   └── exception_handler.dart
│   ├── core/                          # App-wide infrastructure
│   │   ├── common/                    # Shared base classes, logger
│   │   ├── constants/                 # Responsive & theme constants
│   │   ├── data/                      # Data layer infrastructure
│   │   │   ├── cache/                 # Caching layer
│   │   │   ├── db/                    # SQLite DB config, handlers, queries
│   │   │   ├── interceptors/          # Dio interceptors
│   │   │   ├── models/                # Core data models
│   │   │   ├── network/               # Network layer
│   │   │   ├── strategy/              # Data strategies
│   │   │   ├── token/                 # Token management
│   │   │   └── utils/                 # Service enums, typedefs
│   │   ├── device/                    # Device config & capabilities
│   │   ├── environment/               # Flavor/environment configuration
│   │   ├── extensions/                # Dart extension methods
│   │   ├── firebase/                  # Firebase init, analytics, services
│   │   ├── kiosk/                     # Raspberry Pi kiosk controllers
│   │   │   ├── controllers/           # Backlight, window, gesture
│   │   │   ├── platform/             # Platform-specific kiosk code
│   │   │   └── services/             # Kiosk service abstractions
│   │   ├── local_server/              # Shelf-based local HTTP server
│   │   ├── mixins/                    # Shared mixins (date, validators)
│   │   ├── platform/                  # Platform-specific code (web, embedded)
│   │   ├── routing/                   # GoRouter setup & navigation
│   │   ├── splash/                    # Splash screen
│   │   ├── theme/                     # Material 3 theme definitions
│   │   └── utils/                     # Connectivity, helpers, type defs
│   └── l10n/                          # Localization (ARB + generated)
│       ├── app_en.arb
│       ├── app_es.arb
│       ├── app_he.arb
│       ├── app_hi.arb
│       └── app_localizations*.dart    # Generated localization code
└── pubspec.yaml
```

## Public API

### Analytics & Exception Handling

- `analytics_exception_handler/exception_handler.dart` — Singleton `ExceptionHandler` for Dio and network error handling with toast notifications
- `analytics_exception_handler/error_reporting.dart` — `ReportError` utility for logging errors to Crashlytics
- `analytics_exception_handler/custom_exception.dart` — Custom exception types (e.g., `OfflineException`)
- `analytics_exception_handler/analytics_logging.dart` — Analytics event logging

### Database & Offline

- `core/data/db/db_handler.dart` — SQLite database handler abstraction
- `core/data/db/db_handler_registry.dart` — Registry for module-specific DB handlers
- `core/data/db/db_config_repository.dart` — Database configuration repository
- `core/data/db/offline_handler.dart` — Offline queue and sync management
- `core/data/db/offline_injection_module.dart` — DI module for offline infrastructure
- `core/data/db/cubit/db_config_cubit.dart` — BLoC/Cubit for DB configuration state
- `core/data/db/queries/*.sql` — SQL query files for table creation

### Networking

- `core/data/base_service.dart` — Base Dio service with interceptors
- `core/data/urls.dart` — API URL constants
- `core/data/interceptors/` — Dio request/response interceptors
- `core/data/cache/` — Response caching layer
- `core/data/network/` — Network configuration
- `core/data/token/` — Token storage and refresh

### Routing

- `core/routing/routing_exports.dart` — Barrel export for all routing utilities
- `core/routing/navigation_keys.dart` — Global navigator keys
- `core/routing/navigation_utils.dart` — Navigation helper methods
- `core/routing/router_helper.dart` — GoRouter configuration helper
- `core/routing/route_constants.dart` — Named route constants
- `core/routing/notification_navigation_handler.dart` — Deep link handling from notifications

### Theming

- `core/theme/theme.dart` — `CustomTheme` class with light/dark theme data
- `core/theme/light_theme.dart` — Material 3 light theme definition
- `core/theme/dark_theme.dart` — Material 3 dark theme definition
- `core/theme/color_schemes.dart` — Color scheme definitions
- `core/theme/text_themes.dart` — Typography/text theme styles
- `core/theme/component_themes/` — Per-component theme overrides (AppBar, buttons, cards, navigation, data tables)
- `core/theme/constants/` — App colors, font families

### IoT / Kiosk (Raspberry Pi)

- `core/kiosk/kiosk_service.dart` — Kiosk mode service interface
- `core/kiosk/kiosk_service_impl.dart` — Kiosk service implementation
- `core/kiosk/kiosk_injection_module.dart` — DI registration for kiosk services
- `core/kiosk/kiosk_gesture_wrapper.dart` — Gesture handling for kiosk mode
- `core/kiosk/kiosk_state.dart` — Kiosk state management
- `core/kiosk/controllers/backlight_controller.dart` — Display backlight control via `dart_periphery`
- `core/kiosk/controllers/window_manager.dart` — Window management for embedded
- `core/kiosk/controllers/exit_gesture_detector.dart` — Admin exit gesture detection

### Connectivity

- `core/utils/connectivity_handler.dart` — `ConnectivityHandler` singleton for monitoring network state and triggering offline sync

### Environment & Configuration

- `core/environment/environment.dart` — Environment enum and config
- `core/environment/environment_type.dart` — Environment type definitions
- `core/environment/app_configuration.dart` — App-level configuration

### Firebase

- `core/firebase/firebase_initializer.dart` — Firebase initialization
- `core/firebase/firebase_injection_module.dart` — Firebase DI module
- `core/firebase/analytics_route_observer.dart` — Route-aware analytics observer
- `core/firebase/services/` — Firebase service contracts
- `core/firebase/services_impl/` — Firebase service implementations

### Platform

- `core/platform/platform.dart` — Platform detection utilities
- `core/platform/web/` — Web-specific implementations
- `core/platform/embedded/` — Embedded device (Raspberry Pi) implementations
- `core/platform/stubs/` — Platform stubs for conditional imports

### Localization

- `l10n/app_localizations.dart` — Generated `AppLocalizations` class
- `l10n/app_en.arb`, `app_es.arb`, `app_he.arb`, `app_hi.arb` — Localization strings (English, Spanish, Hebrew, Hindi)

### Utilities & Mixins

- `core/mixins/date_formats.dart` — Date formatting mixin
- `core/mixins/validators.dart` — Input validation mixin
- `core/mixins/helper_methods.dart` — General helper mixin
- `core/mixins/notifiers.dart` — Toast/snackbar notification utilities
- `core/mixins/feature_discovery_mixin.dart` — Feature discovery support
- `core/utils/responsive_utils.dart` — Responsive layout utilities
- `core/utils/enums_type_def.dart` — Shared enums and type definitions
- `core/extensions/dio_request_extension.dart` — Dio request extensions
- `core/extensions/responsive_theme_extension.dart` — Responsive theme extension

## Usage

```yaml
# In your feature's pubspec.yaml
dependencies:
  app_core:
    path: ../../packages/core
```

```dart
// Import specific modules
import 'package:app_core/core/routing/routing_exports.dart';
import 'package:app_core/core/theme/theme.dart';
import 'package:app_core/core/utils/connectivity_handler.dart';
import 'package:app_core/core/data/db/db_handler.dart';
import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/kiosk/kiosk_service.dart';
import 'package:app_core/l10n/app_localizations.dart';
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `dio` / `dio_cache_interceptor` | HTTP networking with caching |
| `rxdart` | Reactive stream extensions |
| `sqflite` | Local SQLite database |
| `shared_preferences` | Simple key-value storage |
| `flutter_secure_storage` | Encrypted secure storage |
| `firebase_core` | Firebase initialization |
| `firebase_analytics` | Event tracking and analytics |
| `firebase_auth` | Authentication |
| `firebase_crashlytics` | Crash reporting |
| `firebase_messaging` | Push notifications (FCM) |
| `firebase_remote_config` | Remote configuration |
| `flutter_bloc` | BLoC/Cubit state management |
| `provider` | App-level state (theme, locale) |
| `get_it` | Dependency injection |
| `go_router` | Declarative routing |
| `connectivity_plus` | Network connectivity monitoring |
| `google_fonts` | Google Fonts integration |
| `mqtt_client` | MQTT protocol for IoT |
| `dart_periphery` | Hardware GPIO/I2C for Raspberry Pi |
| `shelf` | Local HTTP server |
| `fpdart` | Functional programming utilities |
| `equatable` | Value equality |
| `google_sign_in` | Google authentication |
| `http_certificate_pinning` | SSL certificate pinning |
| `intl` | Internationalization support |

## Dependent Modules

All 14 feature modules depend on this package:

- [daily_tracker_feature](../../features/daily_tracker_feature/README.md)
- [deep_linking_feature](../../features/deep_linking_feature/README.md)
- [feature_discovery_module](../../features/feature_discovery_module/README.md)
- [feature_localization](../../features/feature_localization/README.md)
- [isolates_feature](../../features/isolates_feature/README.md)
- [push_notifications](../../features/push_notifications/README.md)
- [regular_widgets](../../features/regular_widgets/README.md)
- [responsive_showcase](../../features/responsive_showcase/README.md)
- [routing_feature](../../features/routing_feature/README.md)
- [schools](../../features/schools/README.md)
- [scrolling](../../features/scrolling/README.md)
- [shortcuts_feature](../../features/shortcuts_feature/README.md)
- [smart_control_iot](../../features/smart_control_iot/README.md)
- [smart_control_mqtt](../../features/smart_control_mqtt/README.md)

## Related

- [Root README](../../README.md)
- [UI Kit Package](../ui_kit/README.md)
