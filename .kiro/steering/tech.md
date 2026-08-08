# Tech Stack & Build

## Framework
- Flutter (managed via FVM, currently pinned to 3.38.7)
- Dart SDK >=3.0.5 <4.0.0

## State Management
- `flutter_bloc` / Cubit — primary state management
- `provider` — app-level state (theme, locale)

## Key Libraries
| Category | Package |
|---|---|
| Routing | `go_router` |
| Networking | `dio`, `firebase_database` |
| Local DB | `sqflite`, `shared_preferences`, `flutter_secure_storage` |
| DI | `get_it` |
| Reactive | `rxdart` |
| Functional | `fpdart` |
| Firebase | `firebase_core`, `firebase_messaging`, `firebase_database` |
| Notifications | `flutter_local_notifications` |
| AI | `google_generative_ai` |
| Serialization | `json_annotation` + `json_serializable` (with `build_runner`) |
| Testing | `flutter_test`, `integration_test`, `mocktail`, `bloc_test` |
| Linting | `flutter_lints` |
| IoT | `mqtt_client`, `dart_periphery` |

## Backend
- Firebase Realtime Database for CRUD
- Firebase Hosting for web deployment
- Firebase Cloud Messaging for push notifications

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run (default flavor)
flutter run

# Run with flavor
flutter run --flavor flutter
flutter run --flavor dart

# Code generation (JSON serialization etc.)
dart run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze

# Run unit & widget tests
flutter test

# Run integration tests (mobile)
flutter test integration_test

# Run integration tests (web/Chrome)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome

# Build web
flutter build web
```

## CI/CD
- GitHub Actions: lint, analyze, build (Android/iOS/Web) on PRs to main/develop
- Firebase Hosting auto-deploy on push to main
- Semantic versioning via conventional commits

## Pre-commit Hooks
- Configured via `.pre-commit-config.yaml`
- Install: `pip install pre-commit && pre-commit install`

## Analysis Options
- Base: `package:flutter_lints/flutter.yaml`
- `avoid_print: false` (allowed)
- `directives_ordering: true`
- Suppressed: `depend_on_referenced_packages`, `deprecated_member_use`, `file_names`, `use_build_context_synchronously`
