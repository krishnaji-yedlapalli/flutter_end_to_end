# Regular Widgets

A Material 3 widget catalog and animations showcase demonstrating commonly used Flutter UI components across Material and Cupertino design systems.

## Overview

The Regular Widgets module serves as a gallery/reference for standard Flutter widgets and animation techniques. It presents an interactive catalog organized by category — Material components, Cupertino components, dialogs, animations (implicit, custom implicit, and explicit), tables, text selection, card layouts, steppers, and more. The module uses an adaptive layout that switches between a navigation rail (desktop/landscape) and a list view (portrait/mobile) to let users browse and interact with each widget category.

Key concepts demonstrated:

- **Material 3 Components** — Badges, Checkboxes, Chips, Progress Indicators, Radio Buttons, Segmented Buttons, FABs, Sliders, Switches, Tooltips, Menus, Popup Menus
- **Cupertino Components** — iOS-style widgets for cross-platform comparison
- **Implicit Animations** — Built-in animated widgets (`AnimatedContainer`, etc.)
- **Custom Implicit Animations** — Tween-based custom animations via `TweenAnimationBuilder`
- **Explicit Animations** — Controller-driven animations with `AnimationController`
- **Adaptive Layout** — Responsive navigation (rail vs. list) based on device resolution
- **Widget Lifecycle** — Demonstration of `StatefulWidget` lifecycle callbacks
- **AutomaticKeepAlive** — Preserving widget state in scrollable contexts

## Directory Structure

```
regular_widgets/
├── lib/
│   ├── animations/
│   │   ├── custom_implicit_animation_widgets.dart
│   │   ├── explicit_animation_widgets.dart
│   │   └── implicit_animations_widgets.dart
│   ├── automatic_keep_alive.dart
│   ├── cards_list_view_grid.dart
│   ├── cupertino_components.dart
│   ├── dialogs.dart
│   ├── life_cycle_of_widget.dart
│   ├── material_components.dart
│   ├── regular_widgets_dashboard.dart
│   ├── selectable_text.dart
│   ├── stepper_ui.dart
│   └── tables.dart
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `go_router` | Declarative routing and nested navigation (navigation rail branches) |
| `app_core` | Device configuration, route constants, shared enums |

> The module also uses `ui_kit` at runtime (imported via `app_core`) for responsive layout builders and shared app bar widgets.

## Platform Support

| Platform | Supported |
|----------|-----------|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| macOS    | ✅ |
| Linux    | ✅ |
| Windows  | ✅ |

## Usage

The widget catalog is accessible from the app's home dashboard. Navigate to the "Commonly Used Widgets" section to browse the full catalog.

On desktop/landscape screens, a `NavigationRail` on the left lists all widget categories. Selecting a category displays the corresponding showcase in the content area. On mobile/portrait screens, a simple `ListView` allows tapping into each category.

```dart
// Route to the widgets dashboard
context.push('/home/${RouteConstants.dashboard}');
```
### Navigating to Push Notifications

The feature is accessible from the app's home screen. The route path is:

```
https://flutter-end-to-end.web.app/home/dashboard/materialComponents
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
