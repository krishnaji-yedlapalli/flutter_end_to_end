---
description: Detailed explanation of project architecture and naming conventions
---

# Project Architecture Details

This project uses a **Feature-First** structure combined with **Clean Architecture** principles.

## Folder Hierarchy

- `lib/core/` - Global configurations, service locators, routing, and shared device/environment setup.
- `lib/features/` - Domain-specific features.
- `lib/shared/` - Common widgets and utilities used across features.

## Feature Structure

Each feature in `lib/features/[feature_name]/` should follow this structure:

1. **`domain/`** (Independent of data/UI):
   - `entities/`: Plain data classes.
   - `usecases/`: Business logic operations.
   - `repository/`: Abstract interfaces for data fetching.

2. **`data/`** (Implementation):
   - `datasources/`: Remote (API) or Local (DB) data fetching logic.
   - `repository/`: Actual implementation of domain repositories.
   - `models/`: Data classes with fromJson/toJson (often extending entities).

3. **`presentation/`** (UI):
   - `bloc/` or `cubit/`: State management.
   - `pages/`: Full screens.
   - `widgets/`: Feature-specific small widgets.

4. **`core/`**:
   - `[feature_name]_router_module.dart`: Route definitions for this feature.
   - `[feature_name]_injection_module.dart`: DI registrations using GetIt.

## Naming Conventions for AI Agents

- **Cubits**: `[FeatureName]Cubit` and `[FeatureName]State`.
- **Pages**: `[FeatureName]Page` or `[FeatureName]Screen`.
- **Repositories**: `I[FeatureName]Repository` (Interface) and `[FeatureName]RepositoryImpl`.
- **Routes**: Use static constants in `lib/core/routing/routing.dart`.
