# Schools

A full-featured CRUD module demonstrating Clean Architecture with BLoC pattern, offline-first data persistence, and Firebase Realtime Database integration.

## Overview

The Schools feature is the **canonical reference implementation** for the Flutter End to End project. It showcases how to build a production-grade feature module using Clean Architecture principles with clearly separated data, domain, and presentation layers.

Key concepts demonstrated:

- **Clean Architecture** — strict layer separation with dependency inversion
- **BLoC/Cubit** — reactive state management for UI
- **Offline-first** — local SQLite persistence with automatic Firebase sync when connectivity resumes
- **CRUD operations** — create, read, update, and delete Schools, School Details, and Students
- **Dependency Injection** — feature-scoped registration via `get_it`
- **Declarative Routing** — nested navigation with `go_router`

## Architecture

The module follows a three-layer Clean Architecture pattern where dependencies point inward (presentation → domain ← data).

### Data Layer (`data/`)

Responsible for data access, persistence, and network communication.

- **`local/`** — SQLite database handler (`SchoolsDbHandler`) and raw SQL queries for offline storage
- **`model/`** — JSON-serializable data models (`SchoolModel`, `SchoolDetailsModel`, `StudentModel`) with generated `.g.dart` files
- **`repository/`** — Concrete repository implementations (`SchoolsRepositoryImpl`, `SchoolsDetailsRepositoryImpl`, `StudentsRepositoryImpl`) that coordinate between remote (Firebase) and local (SQLite) data sources

### Domain Layer (`domain/`)

Contains business logic, entity definitions, and repository contracts — free of framework dependencies.

- **`entities/`** — Pure domain entities (`SchoolEntity`, `SchoolDetailsEntity`, `StudentEntity`)
- **`repository/`** — Abstract repository interfaces (`SchoolRepository`, `SchoolDetailsRepository`, `StudentsRepository`)
- **`use_cases/`** — Application-specific business operations:
  - `SchoolsUseCase` / `SchoolModifyUseCase` / `DeleteSchoolUseCase`
  - `SchoolDetailsUseCase` / `SchoolDetailsModifyUseCase`
  - `StudentsUseCase` / `StudentUseCase` / `StudentModifyUseCase` / `DeleteStudentUseCase`

### Presentation Layer (`presentation/`)

Handles UI rendering, user interaction, and state management.

- **`cubit/`** — State management classes:
  - `SchoolsCubit` — manages the schools list
  - `SchoolDetailsBloc` — manages school detail view
  - `StudentsBloc` — manages student list and CRUD
- **`pages/`** — Top-level page widgets (e.g., `SchoolsPage`)
- **`screens/`** — Screen-level widgets for school details and student views
- **`ui_mappers/`** — Transforms domain entities into presentation-friendly UI models
- **`ui_models/`** — Lightweight view models for the UI layer

### Shared (`shared/`)

Feature-scoped models and parameters used across layers.

- **`models/`** — View models and task-flow tracking (`SchoolViewModel`, `StudentViewModel`, `SchoolExecutedTaskModel`)
- **`params/`** — Parameter objects for use-case invocation (`SchoolParams`, `SchoolDetailsParam`, `StudentParams`)

### Core (`core/`)

Feature-level infrastructure: dependency injection, routing, and module wrapper.

- `SchoolsInjectionModule` — registers all repositories, use cases, BLoCs, and mappers with `get_it`
- `SchoolRouterModule` — defines `go_router` routes (`/schools`, `/school-details`, `/student`)
- `SchoolModuleWrapperPage` — shell widget that wraps the feature's navigation subtree

## Directory Structure

```
schools/
├── lib/
│   ├── core/
│   │   ├── school_module_wrapper_page.dart
│   │   ├── schools_injection_module.dart
│   │   └── schools_router_module.dart
│   ├── data/
│   │   ├── local/
│   │   │   ├── queries/
│   │   │   │   └── create_school_table_queries.sql
│   │   │   └── schools_db_handler.dart
│   │   ├── model/
│   │   │   ├── models.dart
│   │   │   ├── school_details_model.dart
│   │   │   ├── school_model.dart
│   │   │   └── student_model.dart
│   │   └── repository/
│   │       ├── repository.dart
│   │       ├── school_details_repository_impl.dart
│   │       ├── school_repository.dart
│   │       ├── schools_repository_impl.dart
│   │       └── students_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── entities.dart
│   │   │   ├── school_details_entity.dart
│   │   │   ├── school_entity.dart
│   │   │   └── student_entity.dart
│   │   ├── repository/
│   │   │   ├── repository.dart
│   │   │   ├── school_details_repository.dart
│   │   │   ├── school_repository.dart
│   │   │   └── students_repository.dart
│   │   └── use_cases/
│   │       ├── school_details_usecase/
│   │       ├── schools_usecase/
│   │       ├── student_usecases/
│   │       └── use_cases.dart
│   ├── presentation/
│   │   ├── cubit/
│   │   │   ├── school_details_bloc/
│   │   │   ├── schools_cubit/
│   │   │   └── students_bloc/
│   │   ├── pages/
│   │   │   └── schools/
│   │   ├── screens/
│   │   │   ├── school_details/
│   │   │   └── student/
│   │   ├── ui_mappers/
│   │   │   └── schools_ui_mapper.dart
│   │   └── ui_models/
│   │       ├── schools_ui_model.dart
│   │       └── student_ui_model.dart
│   └── shared/
│       ├── models/
│       │   ├── school_details_view_model.dart
│       │   ├── school_executed_task_model.dart
│       │   ├── school_view_model.dart
│       │   └── student_view_model.dart
│       └── params/
│           ├── school_details_param.dart
│           ├── school_params.dart
│           └── student_params.dart
├── test/
│   ├── mock_data/
│   ├── unit_testing/
│   │   ├── bloc/
│   │   └── repository/
│   └── widget_testing/
│       └── school/
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit & BLoC) |
| `equatable` | Value equality for state/event classes |
| `fpdart` | Functional programming (Either, Option) for error handling |
| `go_router` | Declarative nested routing |
| `get_it` | Service locator / dependency injection |
| `dio` | HTTP client for Firebase Realtime Database |
| `cached_network_image` | Efficient image loading with caching |
| `loader_overlay` | Loading indicator overlay during async operations |
| `feature_discovery` | Guided feature discovery UI |
| `json_annotation` | JSON serialization annotations |
| `app_core` | Shared infrastructure (DB, networking, routing, theming, analytics) |
| `feature_discovery_module` | Home feature discovery integration |

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_test` | Widget and unit testing framework |
| `mocktail` | Mock generation for testing |
| `bloc_test` | BLoC/Cubit testing utilities |

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ | Full CRUD + offline support |
| iOS      | ✅ | Full CRUD + offline support |
| Web      | ✅ | CRUD via Firebase (no SQLite offline) |
| macOS    | ✅ | Full CRUD + offline support |
| Linux    | ✅ | Runs on Raspberry Pi with Flutter Linux embedding |
| Windows  | ✅ | CRUD supported |

## Usage

### Navigating to Schools

The Schools feature is accessible from the app's home screen via the feature discovery navigation. The route path is:

```
/home/schools
```

### Route Structure

```
/home/schools                              → Schools list page
/home/schools/school-details?schoolId=...  → School detail view
/home/schools/school-details/student?schoolId=...&studentId=...  → Student view
```

### Offline Modes

The module supports three offline storage modes:

1. **Offline Mode** — stores data locally only when no internet is available; syncs automatically when connectivity resumes
2. **Online & Offline Mode** — always stores data locally regardless of connectivity; purges based on configured retention date
3. **Dumping Offline Data** — bulk-loads data into local DB at module initialization for faster subsequent access

### Registering Dependencies

```dart
// Typically called during feature module initialization
await SchoolsInjectionModule().registerDependencies();
```

### Adding Routes

```dart
// In the app-level router configuration
SchoolRouterModule.schoolRoute()
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [Medium Post — Clean Architecture using Flutter BLoC](https://medium.com/@krishnajiyedlapalli60/clean-architecture-using-flutter-bloc-43463e9110db)
- [Web Demo — Schools Feature](https://flutter-end-to-end.web.app/#/home/schools)
- [Web Demo — Full App](https://niccolocastagnola.github.io/flutter_end_to_end/)
