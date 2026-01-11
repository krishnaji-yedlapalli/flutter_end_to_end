---
description: How to build and run the application
---

# Build and Run Workflows

This project is built with **Flutter 3.29.2** and **Dart 3.7.2**.

## Initial Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Initialize Submodules** (Required for `daily_tracker`):
   ```bash
   git submodule update --init --recursive
   ```

3. **Generate code** (if needed for json_serializable, etc.):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Running the App

### Using Flavors:
The project supports `flutter` and `dart` flavors.
```bash
flutter run --flavor flutter
flutter run --flavor dart
```

### Specific device:
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### Platform-specific runs:
```bash
# Web (Chrome)
flutter run -d chrome

# Web Server (Port 3000)
flutter run -d web-server --web-port 3000

# iOS/Android/Desktop
flutter run -d ios
flutter run -d android
flutter run -d macos
```

## Testing

### Unit and Widget Tests:
```bash
flutter test
```

### Integration Tests:

**On Mobile:**
```bash
flutter test integration_test
```

**On Web:**
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome
```

## Code Quality and Git Hooks

This project uses `pre-commit` for quality checks.

1. **Setup Pre-commit**:
   ```bash
   pip install pre-commit
   pre-commit install
   ```

2. **Run Manual Check**:
   ```bash
   pre-commit run --all-files
   ```

3. **Format code**:
   ```bash
   dart format .
   ```

4. **Analyze code**:
   ```bash
   flutter analyze
   ```
