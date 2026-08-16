# Isolates Feature

Demonstrates Dart isolates and concurrency patterns including `compute()`, `Isolate.spawn()`, and long-running worker isolates for offloading expensive computations from the main thread.

## Overview

The Isolates Feature showcases how to leverage Dart's concurrency model to perform CPU-intensive work without blocking the UI. It presents two complementary demo screens:

- **Enhanced Isolates Demo** — a Clean Architecture implementation with Cubit state management, platform-aware isolate selection, configurable workload size, and performance metrics display.
- **Legacy Isolates Demo** — standalone examples of `compute()`, `Isolate.spawn()` with `SendPort`/`ReceivePort`, and a persistent worker isolate pattern.

Key concepts demonstrated:

- **`compute()`** — Flutter's simplified one-shot isolate API (works on all platforms including web)
- **`Isolate.spawn()`** — direct isolate spawning with bidirectional message passing (mobile/desktop only)
- **Long-Running Worker Isolates** — keeping an isolate alive to process multiple tasks without spawn overhead
- **Platform-Aware Concurrency** — detecting web vs. native and falling back gracefully
- **Performance Comparison** — measuring execution time across isolate strategies and data sizes
- **Clean Architecture with Isolates** — structuring use cases that delegate heavy work to isolates

## Architecture

This feature follows Clean Architecture with three layers and an additional `shared/` directory for cross-cutting isolate infrastructure.

### Layers

- **data/** — Repository implementation and dummy data source for generating test datasets
- **domain/** — Entities (User, Product), repository contracts, and use cases (parse JSON, sort data, calculate statistics)
- **presentation/** — `IsolateCubit` for state management, UI screens, and reusable widgets (performance metrics, platform badge)

### Shared

- **`IsolateManager`** — abstract interface defining `executeWithCompute()` and `executeWithSpawn()` contracts
- **`SpawnIsolateManager`** — native implementation using `Isolate.spawn()` with `ReceivePort` communication
- **`ComputeIsolateManager`** — web-safe fallback that routes all operations through `compute()`

## Directory Structure

```
isolates_feature/
├── lib/
│   ├── core/
│   │   └── isolates_injection_module.dart   # GetIt DI registration
│   ├── data/
│   │   ├── datasources/
│   │   │   └── dummy_data_source.dart       # Generates test datasets
│   │   ├── models/
│   │   │   ├── product_model.dart
│   │   │   └── user_model.dart
│   │   └── repositories/
│   │       └── data_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── product.dart
│   │   │   └── user.dart
│   │   ├── repositories/
│   │   │   └── i_data_repository.dart       # Repository contract
│   │   └── usecases/
│   │       ├── calculate_statistics_usecase.dart
│   │       ├── parse_large_json_usecase.dart
│   │       └── sort_data_usecase.dart
│   ├── presentation/
│   │   ├── cubit/
│   │   │   ├── isolate_cubit.dart           # Manages isolate operations
│   │   │   └── isolate_state.dart
│   │   └── widgets/
│   │       ├── performance_metrics_widget.dart
│   │       └── platform_support_badge.dart
│   ├── shared/
│   │   ├── isolate_manager.dart             # Abstract isolate interface
│   │   ├── compute_isolate_manager.dart     # Web-safe compute() wrapper
│   │   └── spawn_isolate_manager.dart       # Native Isolate.spawn() wrapper
│   ├── isolate_examples.dart                # Standalone isolate patterns
│   ├── isolate_home.dart                    # Feature entry point / demo picker
│   ├── isolate_with_compute.dart            # Enhanced demo screen (Clean Arch)
│   └── isolates_screen.dart                 # Legacy demo screen
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | Cubit-based state management for the enhanced demo |
| `get_it` | Dependency injection for use cases and cubits |
| `go_router` | Navigation to legacy isolate screen |
| `app_core` | Device configuration, responsive utilities, enums |

## Platform Support

| Platform | `compute()` | `Isolate.spawn()` | Notes |
|----------|-------------|-------------------|-------|
| Android  | ✅ | ✅ | Full isolate support |
| iOS      | ✅ | ✅ | Full isolate support |
| Web      | ✅ | ❌ | `compute()` uses web workers; `spawn()` unavailable |
| macOS    | ✅ | ✅ | Full isolate support |
| Linux    | ✅ | ✅ | Full isolate support |
| Windows  | ✅ | ✅ | Full isolate support |

> On web, `Isolate.spawn()` is not supported due to browser security restrictions. The feature gracefully falls back to `compute()` and displays platform-support badges in the UI.

## Usage

### Navigating to the Feature

From the app's home screen, select the **Isolates** tile. The feature home presents two demo cards:

```
https://flutter-end-to-end.web.app/home/localization
```

1. **Enhanced Isolates Demo** — Clean Architecture demo with configurable record count, sort type, and side-by-side `compute()` vs `spawn()` comparison
2. **Legacy Demo** — quick-fire examples of Fibonacci, string reversal, worker sums, and JSON parsing

### Using Isolates Programmatically

```dart
// One-shot computation with compute()
final result = await compute(expensiveFunction, inputData);

// Long-running worker pattern
final worker = IsolateWorker();
await worker.start();
final sum = await worker.sumNumbers(10000000);
final primes = await worker.generatePrimes(10000);
worker.dispose();
```

### Using the Clean Architecture Approach

```dart
// Use cases handle isolate delegation internally
final cubit = GetIt.instance<IsolateCubit>();
cubit.parseJsonWithCompute(10000);   // Uses compute()
cubit.sortDataWithSpawn(10000, SortType.name); // Uses Isolate.spawn()
cubit.calculateStatsWithCompute(10000);
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Dart Isolates Documentation](https://dart.dev/language/concurrency)
- [Flutter `compute()` API](https://api.flutter.dev/flutter/foundation/compute-constant.html)
