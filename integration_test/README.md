# Integration Tests

## Overview

End-to-end integration tests that verify complete user flows across the Flutter End to End application. These tests exercise the full application stack including navigation, data persistence, and UI interaction, running on real or emulated devices and browsers.

## Directory Structure

```
integration_test/
└── app_test.dart       # Main integration test entry point
```

The test driver used for web-based execution resides in the project root:

```
test_driver/
└── integration_test.dart   # Driver for flutter drive (web/Chrome)
```

## Running Tests

### Mobile (Android / iOS)

```bash
flutter test integration_test
```

This runs all integration tests on the connected mobile device or emulator.

### Web (Chrome)

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome
```

This launches a Chrome instance and drives the integration test via the `test_driver/integration_test.dart` adapter.

## Testing Strategy

- **Full-stack verification** — Integration tests validate real user journeys spanning multiple screens, services, and data layers.
- **Platform coverage** — Tests are run on both mobile (Android/iOS emulators) and web (Chrome) to catch platform-specific regressions.
- **Single entry point** — `app_test.dart` serves as the consolidated entry point for all integration test scenarios.

## Related

- [Unit & Widget Tests](../test/README.md)
- [Root README](../README.md)
