# Smart Control MQTT

A smart home device control module demonstrating MQTT protocol communication for real-time IoT device management, featuring a dashboard with multiple device types and automated/manual control modes.

## Overview

The Smart Control MQTT feature demonstrates how to integrate MQTT (Message Queuing Telemetry Transport) protocol into a Flutter application for real-time smart home device control. It connects to an MQTT broker to publish commands and subscribe to device status updates, enabling bidirectional communication between the app and IoT devices.

Key concepts demonstrated:

- **MQTT Protocol** — lightweight publish/subscribe messaging for IoT communication
- **Real-time Device Control** — on/off switching, auto/manual modes, and scheduled operations
- **Multiple Device Types** — lights (PIR/diode), exhaust fans, water level sensors, gas detectors, cooking timers
- **BLoC/Cubit** — reactive state management for device status and control
- **Clean Architecture** — partial implementation with data/domain/presentation layers per sub-feature
- **Dependency Injection** — feature-scoped registration via `get_it`

## Architecture

The module uses a partial Clean Architecture pattern organized around sub-features rather than a single unified layer structure. Each sub-feature (e.g., `smart_device_control`, `on_and_off`) maintains its own data/domain/presentation separation internally.

### Feature Organization

- **`dashboard/`** — Main dashboard presentation showing all devices in a staggered grid layout
- **`smart_device_control/`** — Full Clean Architecture sub-feature for controlling individual devices (data → domain → presentation)
- **`on_and_off/`** — Clean Architecture sub-feature for simple on/off device toggling
- **`domain/`** — Shared domain layer with a top-level `SmartControlMqttDashboardCubit` for managing overall dashboard state
- **`mock/`** — Seed data defining available smart devices and their configurations

### MQTT Communication

The module uses `mqtt_client` (via `MqttServerClient`) with a set of well-defined topics:

| Topic | Direction | Purpose |
|-------|-----------|---------|
| `/deviceConnectionStatus` | Subscribe | Receive device online/offline status |
| `/reqConnectionStatus` | Publish | Request current connection status |
| `/control` | Publish | Send on/off commands to devices |
| `/status` | Subscribe | Receive current device state |
| `/updateAutoManualStatus` | Publish | Switch between auto/manual mode |
| `/controlAutoManualStatus` | Subscribe | Receive auto/manual status changes |
| `/updateSettings` | Publish | Send device configuration updates |
| `/updateTimeStatusToClient` | Subscribe | Receive timer/schedule updates |

### Wrapper & Initialization

`SmartControlMqttWrapperPage` acts as the feature shell:
1. Registers all dependencies via `SmartControlMqttInjectionModule`
2. Initializes the MQTT server connection via `MqttServerInitializeWrapper` (from `ui_kit`)
3. Provides BLoC instances (`SmartControlMqttDashboardCubit`, `OnOffCubit`) to the widget subtree
4. Cleans up dependencies on navigation pop

## Directory Structure

```
smart_control_mqtt/
├── lib/
│   ├── core/
│   │   ├── smart_control_mqtt_injection_module.dart
│   │   ├── smart_control_mqtt_router_module.dart
│   │   └── smart_control_mqtt_wrapper_page.dart
│   ├── features/
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       └── smart_control_mqtt_dashboard.dart
│   │   ├── domain/
│   │   │   └── cubit/
│   │   │       ├── smart_control_dashboard_cubit.dart
│   │   │       └── smart_control_dashboard_state.dart
│   │   ├── mock/
│   │   │   └── smart_control_seed.dart
│   │   ├── on_and_off/
│   │   │   ├── data/
│   │   │   │   └── respository/
│   │   │   ├── domain/
│   │   │   │   └── use_cases/
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       └── on_and_off_view.dart
│   │   └── smart_device_control/
│   │       ├── data/
│   │       │   └── respository/
│   │       ├── domain/
│   │       │   ├── repository/
│   │       │   └── use_cases/
│   │       └── presentation/
│   │           ├── cubit/
│   │           ├── dialogs/
│   │           ├── widgets/
│   │           └── smart_control_tile.dart
│   └── shared/
│       ├── constants.dart
│       ├── mixins/
│       │   └── smart_device_mixin.dart
│       ├── models/
│       │   └── smart_control_model.dart
│       └── utils/
│           └── enums.dart
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit) for device control and dashboard |
| `get_it` | Service locator / dependency injection |
| `equatable` | Value equality for state classes |
| `mqtt_client` | MQTT protocol client for broker communication |
| `go_router` | Declarative routing |
| `flutter_staggered_grid_view` | Staggered grid layout for device tiles |
| `shimmer` | Loading placeholder animations |
| `app_core` | Shared infrastructure (base service, routing constants) |

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ | MQTT communication over network |
| iOS      | ✅ | MQTT communication over network |
| Web      | ✅ | WebSocket-based MQTT connection |
| macOS    | ✅ | MQTT communication over network |
| Linux    | ✅ | Primary target for Raspberry Pi smart home hub |
| Windows  | ✅ | MQTT communication over network |

## Usage

### Navigating to Smart Control MQTT

The feature is accessible from the app's home screen. The route path is:

```
/home/smart-control-mqtt/dashboard
```

### Route Structure

```
/home/smart-control-mqtt/dashboard          → Device dashboard (staggered grid)
/home/smart-control-mqtt/dashboard/on-off   → Simple on/off control view
```

### Supported Device Types

| Device Type | Enum | Description |
|-------------|------|-------------|
| PIR Light | `pirLight` | Motion-sensor controlled light |
| Diode Light | `diodeLight` | Standard on/off light |
| Exhaust Fan | `exhaustFan` | Kitchen/bathroom ventilation |
| Water Level | `waterLevel` | Tank level sensor monitor |
| Gas Detector | `gasDetector` | Gas leak detection sensor |
| Scheduled Device | `scheduledDevice` | Timer-based device (e.g., router) |
| Cooking Timer | `cookingTimer` | Kitchen countdown timer |

### MQTT Broker Requirement

This feature requires an MQTT broker to be running and accessible. The connection is initialized via the `MqttServerInitializeWrapper` provided by the `ui_kit` package. Device nodes communicate using unique IDs (e.g., `node1`, `node2`, `node3`).

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Smart Control IoT Feature](../smart_control_iot/README.md) — companion feature using `dart_periphery` for hardware GPIO control
