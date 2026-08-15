# Deep Linking Feature

A showcase module demonstrating deep linking configuration and URL construction for navigating into the Flutter End to End application from external sources.

## Overview

The Deep Linking feature demonstrates how to configure and test deep links in a multi-platform Flutter application. It provides a simple UI where users can construct deep link URLs, copy them to the clipboard, and verify that tapping the link on a device opens the app directly instead of the browser.

Key concepts demonstrated:

- **Deep Linking** — URL-based navigation into specific app screens
- **Clipboard Integration** — programmatic copy via `Clipboard.setData`
- **ValueNotifier** — lightweight reactive state for URL preview
- **Platform URL Schemes** — configuring Android App Links and iOS Universal Links

## Architecture

This feature uses a **flat architecture** with a single presentation-layer widget. It does not implement a full Clean Architecture pattern (no separate data or domain layers) since the feature's scope is limited to URL construction and clipboard interaction with no data persistence or business logic.

### Presentation

- **`DeepLinkingTesting`** — A `StatelessWidget` that provides a text field for entering a route path, displays a live URL preview, and offers a copy-to-clipboard action

### Core Dependencies Used

- `Validators` mixin from `app_core` — input validation support
- `CustomAppBar` and `CustomTextField` from `ui_kit` — reusable UI components
- `screenPadding()` extension from `ui_kit` — consistent layout spacing

## Directory Structure

```
deep_linking_feature/
├── lib/
│   └── deep_linking.dart    # Main feature widget (DeepLinkingTesting)
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter` | Flutter SDK |
| `app_core` | Validators mixin for input validation |
| `ui_kit` | Shared UI components (CustomAppBar, CustomTextField) and extensions |

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ | App Links configured for deep link handling |
| iOS      | ✅ | Universal Links configured for deep link handling |
| Web      | ✅ | URL-based routing via path segments |
| macOS    | ✅ | Basic deep link support |
| Linux    | ✅ | Basic deep link support |
| Windows  | ✅ | Basic deep link support |

## Usage

### Navigating to Deep Linking

The feature is accessible from the app's home screen. The route path is:

```
/home/deep-linking
```

### How It Works

1. Enter a path segment in the text field (e.g., `schools`)
2. The widget constructs the full URL: `https://flutter-end-to-end.web.app/home/schools`
3. Tap the copy icon to copy the URL to the clipboard
4. Paste the URL in a browser, notes app, or messages app on the same device
5. Tapping the URL opens the Flutter app directly (when installed) instead of the device browser

### Base URL

```
https://flutter-end-to-end.web.app/home/
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Web Demo](https://flutter-end-to-end.web.app/)
