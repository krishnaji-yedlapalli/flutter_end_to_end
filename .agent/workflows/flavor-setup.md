# Flutter Flavors Setup Guide

This project supports multiple flavors (app variants) with different branding and configurations.

## Available Flavors

1. **Dash** (Default) - Default Flutter End to End app
2. **Flutter** - Flutter-branded version with blue theme
3. **Dart** - Dart-branded version with indigo theme  
4. **Daily Tracker** - Specialized daily tracking app

## Android Studio Setup

### 1. Import Project
- Open Android Studio
- Import the project
- Wait for Gradle sync to complete

### 2. Select Build Variant
- Go to **View → Tool Windows → Build Variants**
- Select desired flavor from dropdown:
  - `dashDebug` / `dashRelease`
  - `flutterDebug` / `flutterRelease`
  - `dartDebug` / `dartRelease`
  - `dailyTrackerDebug` / `dailyTrackerRelease`

### 3. Run Configurations
Pre-configured run configurations will appear in the dropdown:
- **Dash Debug**
- **Flutter Flavor Debug**
- **Dart Flavor Debug**
- **Daily Tracker Debug**

## Command Line Usage

```bash
# Default flavor
flutter run

# Specific flavors
flutter run --flavor dash --dart-define=FLUTTER_APP_FLAVOR=dash
flutter run --flavor flutter --dart-define=FLUTTER_APP_FLAVOR=flutter
flutter run --flavor dart --dart-define=FLUTTER_APP_FLAVOR=dart
flutter run --flavor dailyTracker --dart-define=FLUTTER_APP_FLAVOR=dailyTracker
```

## Building for Release

```bash
# Android APK
flutter build apk --flavor flutter --dart-define=FLUTTER_APP_FLAVOR=flutter

# Android App Bundle
flutter build appbundle --flavor flutter --dart-define=FLUTTER_APP_FLAVOR=flutter

# iOS
flutter build ios --flavor flutter --dart-define=FLUTTER_APP_FLAVOR=flutter
```

## VS Code Setup

The project includes `.vscode/launch.json` with pre-configured debug configurations:
- Open **Run and Debug** panel (Ctrl+Shift+D)
- Select desired flavor from dropdown
- Press F5 to run

## Troubleshooting

### Flavors not showing in Android Studio
1. Ensure Gradle sync completed successfully
2. Check `android/app/build.gradle` for `productFlavors` section
3. Restart Android Studio if needed

### Build errors
1. Clean project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Rebuild: `flutter run --flavor <flavor_name>`

## Flavor Differences

| Feature | Dash | Flutter | Dart | Daily Tracker |
|---------|------|---------|------|---------------|
| App Name | Flutter End to End | Flutter End to End - Flutter | Flutter End to End - Dart | Daily Tracker |
| Package ID | com.example.sample_latest | com.example.sample_latest.flutter | com.example.sample_latest.dart | com.example.sample_latest.dailytracker |
| Theme Color | Green | Blue | Indigo | Blue |
| Logo | Dash logo | Flutter logo | Dart logo | Flutter logo |
| Initial Route | /home | /home | /home | /login |
