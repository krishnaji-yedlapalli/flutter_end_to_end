# Feature Localization

Showcases Flutter's internationalization (i18n) and localization (l10n) capabilities with LTR/RTL text direction support across multiple locales.

## Overview

The Feature Localization module demonstrates how to build a fully localized Flutter application supporting four locales:

| Locale Code | Language | Direction |
|-------------|----------|-----------|
| `en` | English | LTR |
| `es` | Spanish | LTR |
| `hi` | Hindi | LTR |
| `he` | Hebrew | RTL |

Key concepts demonstrated:

- **Runtime Locale Switching** — users can change the app language at runtime via a dropdown, with all UI strings updating immediately
- **LTR/RTL Support** — Hebrew locale triggers automatic right-to-left layout
- **Locale Override** — demonstrates `Localizations.override()` to display a section of the UI in a different locale than the app-wide setting
- **ICU Message Syntax** — plurals, select statements, number formatting (compact, currency, percent), date formatting, and dynamic string interpolation
- **Escaped Interpolation** — handling curly-brace escape sequences in ARB files
- **Localized Material Widgets** — `CalendarDatePicker` and `TimePickerDialog` adapt to the active locale

## Directory Structure

```
feature_localization/
├── lib/
│   └── localization.dart    # LocalizationDatePicker page (main showcase widget)
└── pubspec.yaml
```

> **Note:** ARB translation files and generated localizations live in the `packages/core/lib/l10n/` directory and are shared across all features.

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | Reads and updates the active locale via `CommonProvider` |
| `app_core` | Provides `AppLocalizations`, device configuration, and generated locale delegates |

> The module also imports `ui_kit` for shared UI components (`CustomAppBar`, `HelperWidget` mixin, screen padding extensions).

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

### Navigating to the Localization Screen

The localization showcase is accessible from the app's home/dashboard. It renders as the `LocalizationDatePicker` widget.

```
https://flutter-end-to-end.web.app/home/localization
```

### Changing the App Locale

```dart
// The dropdown triggers this via CommonProvider
context.read<CommonProvider>().onChangeOfLanguage(newLocale);
```

### Overriding Locale for a Sub-Tree

```dart
Localizations.override(
  locale: overrideLocale,
  context: context,
  child: Builder(builder: (context) {
    // Widgets here use overrideLocale instead of the app-wide locale
    return Text(AppLocalizations.of(context)!.sampleText1);
  }),
);
```

### Adding a New Locale

1. Create a new ARB file in `packages/core/lib/l10n/` (e.g., `app_fr.arb`)
2. Run `flutter gen-l10n` to regenerate the delegate code
3. The new locale will appear in the dropdown automatically via `AppLocalizations.supportedLocales`

## References

- [Root README](../../README.md)
- [Core Package (`app_core`)](../../packages/core/README.md)
- [Flutter Internationalization Guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
