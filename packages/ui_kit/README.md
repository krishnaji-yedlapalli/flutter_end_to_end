# UI Kit

Shared UI components, widgets, mixins, and presentation utilities for all feature modules.

## Overview

The `ui_kit` package provides a centralized library of reusable Flutter widgets, responsive/adaptive UI components, mixins for common UI patterns (buttons, cards, dialogs, loaders), context extensions, and shared providers. It serves as the UI building block layer that feature modules depend on to maintain consistent look-and-feel and reduce code duplication across the application.

This package depends on [`app_core`](../core/README.md) for device configuration and infrastructure, and re-exports higher-level presentation utilities that features consume directly.

## Public API

### Extensions

- `extensions/build_context.dart` — BuildContext convenience extensions
- `extensions/widget_extension.dart` — Widget utility extensions (e.g., validators)

### Mixins

- `mixins/buttons_mixin.dart` — Reusable button builder methods
- `mixins/cards_mixin.dart` — Card layout helper methods
- `mixins/dialogs.dart` — Custom dialog display utilities
- `mixins/helper_widgets_mixin.dart` — General-purpose widget helpers
- `mixins/loaders.dart` — Loading indicator utilities

### Responsive Widgets

Adaptive widgets that scale based on screen size and device type:

- `widgets/responsive_widgets/adapative_container.dart` — Responsive container
- `widgets/responsive_widgets/adapative_padding.dart` — Responsive padding
- `widgets/responsive_widgets/adaptive_button.dart` — Adaptive button
- `widgets/responsive_widgets/adaptive_card.dart` — Adaptive card
- `widgets/responsive_widgets/adaptive_dialog.dart` — Adaptive dialog
- `widgets/responsive_widgets/adaptive_layout_builder.dart` — Layout builder with breakpoints
- `widgets/responsive_widgets/adaptive_loading_indicator.dart` — Loading indicator
- `widgets/responsive_widgets/adaptive_navigation_bar.dart` — Navigation bar
- `widgets/responsive_widgets/adaptive_slider.dart` — Adaptive slider
- `widgets/responsive_widgets/adaptive_switch.dart` — Adaptive switch
- `widgets/responsive_widgets/adaptive_widgets.dart` — Composite adaptive widget set
- `widgets/responsive_widgets/optimized_adaptive_widgets.dart` — Performance-optimized variants
- `widgets/responsive_widgets/responsive_widgets.dart` — Responsive utility widgets

#### Responsive Buttons

- `widgets/responsive_widgets/buttons/adaptive_responsive_button.dart` — Standard responsive button
- `widgets/responsive_widgets/buttons/adaptive_responsive_compact_button.dart` — Compact button variant
- `widgets/responsive_widgets/buttons/adaptive_responsive_fab.dart` — Floating action button
- `widgets/responsive_widgets/buttons/adaptive_responsive_icon_button.dart` — Icon button
- `widgets/responsive_widgets/buttons/adaptive_responsive_large_button.dart` — Large button variant
- `widgets/responsive_widgets/buttons/adaptive_responsive_outline_button.dart` — Outline button

#### Responsive Text Widgets

- `widgets/responsive_widgets/text_widgets/responsive_header.dart` — Responsive header text
- `widgets/responsive_widgets/text_widgets/responsive_sub_header.dart` — Responsive sub-header
- `widgets/responsive_widgets/text_widgets/responsive_subtitle.dart` — Responsive subtitle
- `widgets/responsive_widgets/text_widgets/responsive_text.dart` — Responsive body text
- `widgets/responsive_widgets/text_widgets/responsive_title.dart` — Responsive title text

### Non-Responsive Widgets

Standard widgets without adaptive scaling:

- `widgets/non_responsive_widgets/custom_app_bar.dart` — Custom AppBar widget
- `widgets/non_responsive_widgets/custom_dropdown.dart` — Custom dropdown widget
- `widgets/non_responsive_widgets/text_field.dart` — Custom text field widget

### Local Server Wrappers

Widgets that manage server/broker lifecycle for IoT features:

- `widgets/local_server/server_initilize_wrapper.dart` — Shelf-based local HTTP server initialization wrapper
- `widgets/local_server/mqtt_server_initilize_wrapper.dart` — MQTT broker connection wrapper

### Presentation Utilities

#### Providers

- `presentation/provider/common_provider.dart` — App-wide theme and locale state (ChangeNotifier)
- `presentation/provider/route_provider.dart` — Route counter state for shell routing demos

#### Screens

- `presentation/screens/db_configurations_for_devs.dart` — Developer DB configuration dialog
- `presentation/screens/dumping_status.dart` — Data dumping progress view

### Standalone Widgets

- `exception.dart` — Error/exception state display widget (no internet, server not found, timeout, etc.)
- `page_not_found.dart` — 404 page widget for unknown routes

## Usage

```yaml
# In your feature's pubspec.yaml
dependencies:
  ui_kit:
    path: ../../packages/ui_kit
```

```dart
// Import responsive widgets
import 'package:ui_kit/widgets/responsive_widgets/widgets.dart';

// Import non-responsive widgets
import 'package:ui_kit/widgets/non_responsive_widgets/non_responsive_widgets.dart';

// Import mixins (buttons, cards, dialogs, loaders)
import 'package:ui_kit/mixins/mixins.dart';

// Import extensions
import 'package:ui_kit/extensions/extensions.dart';

// Import providers
import 'package:ui_kit/presentation/provider/common_provider.dart';
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `app_core` | Core infrastructure (device config, local server, l10n) |
| `flutter_bloc` | State management |
| `provider` | ChangeNotifier-based state (theme, locale) |
| `equatable` | Value equality for state objects |
| `get_it` | Dependency injection |
| `go_router` | Navigation and routing |
| `google_fonts` | Custom font loading |
| `loader_overlay` | Full-screen loading overlay |
| `fluttertoast` | Toast notifications |
| `liquid_progress_indicator_v2` | Liquid progress animations |
| `feature_discovery` | Feature discovery/onboarding overlays |
| `mqtt_client` | MQTT broker connectivity for IoT wrappers |
| `shelf` | Local HTTP server for IoT wrappers |

## Dependent Modules

The following feature modules depend on this package:

- [schools](../../features/schools/README.md)
- [deep_linking_feature](../../features/deep_linking_feature/README.md)
- [feature_discovery_module](../../features/feature_discovery_module/README.md)
- [feature_localization](../../features/feature_localization/README.md)
- [isolates_feature](../../features/isolates_feature/README.md)
- [push_notifications](../../features/push_notifications/README.md)
- [regular_widgets](../../features/regular_widgets/README.md)
- [responsive_showcase](../../features/responsive_showcase/README.md)
- [routing_feature](../../features/routing_feature/README.md)
- [scrolling](../../features/scrolling/README.md)
- [shortcuts_feature](../../features/shortcuts_feature/README.md)
- [smart_control_iot](../../features/smart_control_iot/README.md)
- [smart_control_mqtt](../../features/smart_control_mqtt/README.md)

## Directory Structure

```
ui_kit/
├── lib/
│   ├── extensions/              # BuildContext and Widget extensions
│   ├── mixins/                  # UI pattern mixins (buttons, cards, dialogs, loaders)
│   ├── presentation/
│   │   ├── provider/            # ChangeNotifier providers (theme, locale, route)
│   │   └── screens/             # Shared developer utility screens
│   ├── widgets/
│   │   ├── local_server/        # Server/MQTT initialization wrappers
│   │   ├── non_responsive_widgets/  # Standard widgets (app bar, dropdown, text field)
│   │   └── responsive_widgets/      # Adaptive/responsive widget library
│   │       ├── buttons/         # Responsive button variants
│   │       └── text_widgets/    # Responsive text/typography widgets
│   ├── exception.dart           # Error state display widget
│   └── page_not_found.dart      # 404 page widget
├── analysis_options.yaml
└── pubspec.yaml
```

## Related

- [Root README](../../README.md)
- [Core Package (`app_core`)](../core/README.md)
