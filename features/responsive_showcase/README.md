# Responsive Showcase

Demonstrates responsive and adaptive UI patterns that work seamlessly across all screen sizes and platforms, from mobile phones to large desktops.

## Overview

The Responsive Showcase module is an interactive reference for building responsive Flutter UIs. It displays a collection of adaptive widgets and layout patterns that automatically adjust based on the current device's screen size, resolution type, and platform. The feature leverages `DeviceConfiguration` (from `app_core`) and responsive widget primitives (from `ui_kit`) to demonstrate how a single codebase can deliver an optimised experience on every form factor.

Key concepts demonstrated:

- **Responsive Text** — typography that scales across device breakpoints (header, title, body, caption)
- **Adaptive Buttons** — buttons that adapt size, padding, and style to platform and screen size (standard, compact, large, outline, icon, FAB)
- **Responsive Grids** — grid layouts that change column count based on resolution (mobile → tablet → desktop)
- **Adaptive Card Layouts** — cards that switch between vertical stacking (mobile) and horizontal row (desktop)
- **Responsive Spacing & Padding** — spacing utilities that scale proportionally with a device-dependent scale factor
- **Device Info Display** — real-time readout of resolution type, screen dimensions, scale factor, grid columns, orientation, and platform design language (Material vs Cupertino)

## Directory Structure

```
responsive_showcase/
├── lib/
│   ├── responsive_showcase.dart              # Barrel file (public exports)
│   ├── pages/
│   │   └── responsive_showcase_page.dart     # Main page with CustomScrollView
│   ├── sections/
│   │   ├── button_widgets_section.dart       # Adaptive button examples
│   │   ├── device_info_section.dart          # Current device metrics display
│   │   ├── layout_examples_section.dart      # Responsive grid/card/list patterns
│   │   └── text_widgets_section.dart         # Responsive text hierarchy showcase
│   └── widgets/
│       ├── responsive_showcase_app_bar.dart   # Responsive SliverAppBar
│       └── showcase_section_card.dart         # Reusable section card wrapper
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter` | Core Flutter SDK |
| `app_core` | `DeviceConfiguration` utilities for breakpoints, scaling, and platform detection |

> **Note:** The module also uses `ui_kit` responsive widget primitives (`ResponsiveHeader`, `ResponsiveText`, `AdaptiveResponsiveButton`, etc.) imported in its source files.

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

Navigate to the Responsive Showcase screen from the app's home/feature discovery menu. The page renders a `CustomScrollView` with the following sections:

1. **Welcome** — feature highlights grid showing multi-platform, responsive, adaptive design, and performance concepts
2. **Device Information** — live device metrics (resolution type, screen size, scale factor, grid columns, orientation, platform design)
3. **Responsive Text Widgets** — text hierarchy (Header → SubHeader → Title → Subtitle → Body → Small → Caption) with styling and alignment examples
4. **Responsive Button Widgets** — standard, compact, large, outline, icon, and FAB button variants
5. **Responsive Layout Examples** — grids, cards, lists, and spacing demonstrations with inline code snippets

### Importing the Feature

```dart
import 'package:responsive_showcase/responsive_showcase.dart';

// Use the main page widget
const ResponsiveShowcasePage();
```

### Responsive Widget Usage Patterns

```dart
// Responsive spacing scales with device type
SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16));

// Responsive padding adapts per breakpoint
DeviceConfiguration.getResponsivePadding(base: 16.0);

// Grid columns adjust automatically
DeviceConfiguration.getGridColumnCount(); // 2 on mobile, 3 on tablet, 4 on desktop

// Conditional layout based on resolution
if (DeviceConfiguration.isDesktopResolution) {
  return _buildHorizontalCards();
} else {
  return _buildVerticalCards();
}
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
