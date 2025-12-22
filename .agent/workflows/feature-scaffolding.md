---
description: Steps to add a new feature including DI and Routing
---

# Feature Scaffolding Workflow

Follow these steps to ensure a new feature is correctly integrated into the system.

## 1. Directory Setup
Create the standard Clean Architecture folders:
`lib/features/[new_feature]/...` (domain, data, presentation, core)

## 2. Dependency Injection
Every feature should have its own injection module:
- Create `lib/features/[new_feature]/core/[new_feature]_injection_module.dart`.
- Use `GetIt.instance` to register Cubits, Repositories, and UseCases.
- Call the initialization in `lib/main.dart` or via a central injection manager.

## 3. Routing
- Create `lib/features/[new_feature]/core/[new_feature]_router_module.dart`.
- Define a `RouteBase` (usually a `GoRoute`).
- Link the route in the master routing file: `lib/core/routing/routing.dart`.

## 4. State Management Integration
- Use `BlocProvider` or `MultiBlocProvider` in the `presentation/` layer.
- Ensure the Cubit is registered in the DI module to allow easy lookup.

## Tips for AI Agents
- Check `lib/features/smart_control_iot/core/` for a reference implementation of DI and Router modules.
- Always use typed routes instead of hardcoded strings where possible.
