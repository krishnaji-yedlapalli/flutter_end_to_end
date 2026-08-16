# Smart Control IoT

A hardware-oriented feature module demonstrating IoT device control via direct GPIO, I2C, and SPI access on Raspberry Pi using the `dart_periphery` package and a local Shelf HTTP server for inter-device communication.

## Overview

The Smart Control IoT feature showcases how Flutter on Linux (specifically Raspberry Pi) can interact with physical hardware peripherals. It provides a dashboard UI for controlling smart devices — toggling GPIOs, reading motion sensors, and managing on/off states — through a combination of local HTTP requests and direct hardware pin access via `dart_periphery`.

Key concepts demonstrated:

- **IoT device control** — GPIO pin manipulation for on/off switching and sensor reading
- **dart_periphery integration** — low-level Linux hardware access (GPIO, I2C, SPI) from Dart
- **Local HTTP server** — Shelf-based server running on the Pi to receive sensor events (e.g., motion detection)
- **Embedded Flutter** — Flutter Linux embedding on Raspberry Pi with touch display
- **Clean Architecture (partial)** — data/domain/presentation layers within sub-features
- **BLoC/Cubit** — reactive state management for device status

## Architecture

The module uses a partial Clean Architecture approach. Rather than a single top-level data/domain/presentation split, the module organizes around sub-features (e.g., `on_and_off`, `smart_device_control`) that each implement their own layered architecture internally.

### Core (`core/`)

Feature-level infrastructure including DI, routing, and a local Shelf HTTP server.

- `SmartControlInjectionModule` — registers repositories, use cases, and cubits with `get_it`
- `SmartControlRouterModule` — defines `go_router` routes for dashboard and on/off views
- `SmartControlWrapperPage` — shell widget wrapping the feature's navigation subtree
- **`local_server/`** — Shelf-based HTTP request handler that receives callbacks from IoT devices (e.g., motion sensor events pushed from Raspberry Pi GPIO pins)

### Sub-Features (`features/`)

Each sub-feature implements its own layered architecture:

- **`dashboard/`** — main dashboard presentation showing all connected devices in a staggered grid
- **`domain/`** — shared cubit (`SmartControlDashboardCubit`) managing overall device state
- **`on_and_off/`** — full data/domain/presentation stack for simple GPIO on/off control
- **`smart_device_control/`** — full data/domain/presentation stack for HTTP-based device control (sends `turnOn`/`turnOff`/`status` commands to device endpoints)

### Shared (`shared/`)

Feature-scoped models and utilities.

- **`models/`** — `SmartControlModel` defining device properties (name, control type, IP address, active state)
- **`utils/`** — enums (`SmartControlType`, `TileSizeType`) for device classification and UI layout

### Hardware Access Layer (via `app_core`)

The actual `dart_periphery` integration lives in the core package's embedded platform layer:

- `GpioService` — opens/closes GPIO pins, reads/writes digital values, provides pin change streams
- `MotionSensorHandler` — monitors PIR motion sensors via GPIO
- `BuzzerController` — drives a piezo buzzer via GPIO
- `CameraController` — interfaces with camera hardware
- `BacklightController` — controls the Raspberry Pi touch display backlight via sysfs

## Directory Structure

```
smart_control_iot/
├── lib/
│   ├── core/
│   │   ├── local_server/
│   │   │   └── local_server_handler/
│   │   │       └── local_server_handler.dart
│   │   ├── smart_control_injection_module.dart
│   │   ├── smart_control_router_module.dart
│   │   └── smart_control_wrapper_page.dart
│   ├── features/
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       └── smart_control_dashboard.dart
│   │   ├── domain/
│   │   │   └── cubit/
│   │   │       └── smart_control_dashboard_cubit.dart
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
│   │       │       └── smart_device_control_repo_impl.dart
│   │       ├── domain/
│   │       │   ├── repository/
│   │       │   │   └── smart_device_control_repo.dart
│   │       │   └── use_cases/
│   │       │       ├── device_status_useCase.dart
│   │       │       └── smart_device_ctrl_useCase.dart
│   │       └── presentation/
│   └── shared/
│       ├── models/
│       │   └── smart_control_model.dart
│       └── utils/
│           └── enums.dart
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit) for device control UI |
| `get_it` | Service locator / dependency injection |
| `fpdart` | Functional programming (Either, Option) for error handling |
| `equatable` | Value equality for state classes |
| `shelf` | Local HTTP server for receiving IoT device callbacks |
| `shelf_router` | Route handling for the local HTTP server |
| `go_router` | Declarative routing within the feature |
| `flutter_staggered_grid_view` | Staggered grid layout for the device dashboard |
| `app_core` | Shared infrastructure — includes `dart_periphery` GPIO service, kiosk controllers, networking, and base service |

### Hardware Dependencies (via `app_core`)

| Package | Purpose |
|---------|---------|
| `dart_periphery` | Direct GPIO, I2C, and SPI access on Linux (Raspberry Pi) |
| `flutter_lite_camera` | Camera hardware access for embedded devices |

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ❌ | No GPIO/hardware access |
| iOS      | ❌ | No GPIO/hardware access |
| Web      | ❌ | No GPIO/hardware access |
| macOS    | ❌ | No GPIO/hardware access |
| Linux    | ✅ | Raspberry Pi with Flutter Linux embedding |
| Windows  | ❌ | No GPIO/hardware access |

> **Note:** This feature is designed exclusively for Raspberry Pi running Linux. The `dart_periphery` package requires direct access to `/dev/gpiochip*` and `/sys/class/` device files which are only available on Linux-based SBCs.

## Usage

### Hardware Requirements

- Raspberry Pi (3B+, 4, or 5) running Raspberry Pi OS
- Official Raspberry Pi Touch Display (for kiosk mode)
- GPIO-connected peripherals (relays, PIR motion sensors, buzzers)
- Network connectivity (for inter-device HTTP communication)

### Navigating to Smart Control

The Smart Control IoT feature is accessible from the app's home screen. The route path is:

```
/home/smart-control/dashboard
```

### Route Structure

```
/home/smart-control/dashboard     → Device dashboard (staggered grid)
/home/smart-control/dashboard/on-off  → On/Off control view
```

### Device Communication

The module communicates with IoT devices via HTTP:

```
GET http://<device_ip>/status   → Query device on/off state
GET http://<device_ip>/turnOn   → Turn device on
GET http://<device_ip>/turnOff  → Turn device off
```

A local Shelf server also runs on the Pi to receive incoming sensor data (e.g., motion detection events) from other networked devices.

### Kiosk Setup

For running as a dedicated kiosk appliance on Raspberry Pi:

```bash
# Set up permissions for GPIO and display access
sudo ./scripts/setup_kiosk_permissions.sh

# Install the systemd service
sudo cp scripts/kiosk-app.service /etc/systemd/system/
sudo systemctl enable kiosk-app
sudo systemctl start kiosk-app
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Smart Control MQTT (companion feature)](../smart_control_mqtt/README.md)
- [dart_periphery on pub.dev](https://pub.dev/packages/dart_periphery)
