# Feature Discovery Module

Provides guided feature discovery overlays (onboarding tours) for the home screen and schools screen, highlighting key UI elements and functionality for first-time users.

## Overview

The Feature Discovery Module uses the [`feature_discovery`](https://github.com/maheshmnj/feature_discovery) package to present contextual overlay tooltips that walk users through important features when they first visit a screen. It manages discovery state via `shared_preferences` so tours are shown only once per user (unless explicitly re-triggered).

Two singleton classes handle discovery flows:

- **`HomeScreenFeatureDiscovery`** — guides users through the home screen, introducing available app modules and platform install options (Android/iOS)
- **`SchoolScreenFeatureDiscovery`** — guides users through the Schools feature's toolbar actions (create, sync, offline dump, DB config, reset) with platform-specific overlays (web vs. mobile)

Key concepts demonstrated:

- **Feature Discovery Overlays** — guided onboarding with `DescribedFeatureOverlay` widgets
- **Singleton Pattern** — single instance per discovery flow ensures consistent state
- **Platform-Aware Behaviour** — different feature sets shown on web vs. mobile
- **Persistence** — discovery completion state saved via `SharedPreferences`

## Directory Structure

```
feature_discovery_module/
├── lib/
│   ├── home_feature_discovery.dart      # Home screen onboarding tour
│   └── school_feature_discovery.dart    # Schools screen onboarding tour
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `feature_discovery` | Overlay-based guided feature tour UI |
| `shared_preferences` | Persists whether a tour has been shown |
| `app_core` | Device configuration, constants, and enum definitions |

> **Note:** The module also imports `ui_kit` (via `ButtonMixin`) for shared UI components such as the dismiss button.

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ | Mobile-specific feature set in Schools tour |
| iOS      | ✅ | Mobile-specific feature set in Schools tour |
| Web      | ✅ | Web-specific feature set (CRUD-only overlays) |
| macOS    | ✅ | Follows mobile feature set |
| Linux    | ✅ | Follows mobile feature set |
| Windows  | ✅ | Follows mobile feature set |

## Usage

### Starting a Discovery Tour

```dart
// Home screen — call in initState or after build
HomeScreenFeatureDiscovery().startFeatureDiscovery(context);

// Schools screen — call after navigating to schools
SchoolScreenFeatureDiscovery().startFeatureDiscovery(context);

// Force re-show the tour (e.g., from a "Show Tour" button)
HomeScreenFeatureDiscovery().startFeatureDiscovery(context, forceTour: true);
```

### Wrapping a Widget with a Discovery Overlay

```dart
// Schools screen — wrap an action button
SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
  child: IconButton(icon: Icon(Icons.add), onPressed: _create),
  type: SchoolDiscoverFeatureType.create,
);

// Home screen — wrap a navigation tile
HomeScreenFeatureDiscovery().aboutModuleDiscovery(
  schoolTileWidget,
  ScreenType.school,
);
```

### App-Level Setup

The parent app must wrap the relevant subtree with `FeatureDiscovery` (from the `feature_discovery` package):

```dart
FeatureDiscovery(
  child: MaterialApp(...),
);
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [`feature_discovery` package](https://github.com/maheshmnj/feature_discovery)
