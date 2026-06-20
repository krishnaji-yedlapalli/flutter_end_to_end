# Project Structure

```
lib/
├── main.dart                          # App entry point, Firebase init, providers
├── analytics_exception_handler/       # Error reporting & analytics logging
├── core/                              # App-wide infrastructure
│   ├── common/                        # Shared base classes
│   ├── config/                        # App configuration
│   ├── constants/                     # App-wide constants
│   ├── data/                          # Core data layer (DB config, queries)
│   ├── device/                        # Device configuration & capabilities
│   ├── environment/                   # Environment/flavor configuration
│   ├── extensions/                    # Dart extension methods
│   ├── local_server/                  # Shelf-based local HTTP server
│   ├── mixins/                        # Shared mixins
│   ├── platform/                      # Platform-specific code (web, etc.)
│   ├── routing/                       # GoRouter setup & navigation keys
│   ├── theme/                         # Material 3 theme definitions
│   └── utils/                         # Utilities (connectivity, helpers)
├── features/                          # Feature modules (vertical slices)
│   ├── schools/                       # Reference feature — full Clean Architecture
│   │   ├── core/                      # Feature-level DI, routing, wrapper
│   │   ├── data/                      # Repositories, models, local DB
│   │   │   ├── local/
│   │   │   ├── model/
│   │   │   └── repository/
│   │   ├── domain/                    # Entities, repository contracts, use cases
│   │   │   ├── entities/
│   │   │   ├── repository/
│   │   │   └── use_cases/
│   │   ├── presentation/             # Cubits, pages, screens, UI mappers
│   │   │   ├── cubit/
│   │   │   ├── pages/
│   │   │   ├── screens/
│   │   │   ├── ui_mappers/
│   │   │   └── ui_models/
│   │   └── shared/                   # Feature-scoped shared models/params
│   ├── dashboard/
│   ├── push_notifcations/            # Note: typo in folder name is intentional
│   ├── deep_linking/
│   ├── generative_ai/
│   ├── daily_tracker/                # Private submodule
│   └── ...                           # Other feature modules
├── l10n/                             # Localization ARB files & generated code
└── shared/                           # Cross-feature shared code
    ├── exception/
    ├── extensions/
    ├── mixins/
    ├── presentation/                 # Shared providers (CommonProvider)
    └── widgets/                      # Reusable widgets

test/
├── mock_data/                        # Test fixtures
├── unit_testing/                     # Unit tests (bloc, repository)
└── widget_testing/                   # Widget tests

integration_test/                     # Integration tests
asset/                                # Images, icons, sounds, GIFs per flavor
android/, ios/, macos/, linux/, web/, windows/  # Platform runners
```

## Architecture Patterns

- Clean Architecture with three layers: `data/`, `domain/`, `presentation/`
- The `schools` feature is the canonical reference implementation
- Features are self-contained vertical slices under `lib/features/`
- Each feature can have its own DI module (`*_injection_module.dart`), router module (`*_router_module.dart`), and wrapper page
- `get_it` for dependency injection, registered per feature module
- BLoC/Cubit for presentation-layer state management
- `provider` at the app root for cross-cutting concerns (theme, locale)
- GoRouter for declarative routing with nested navigation

## Conventions
- Package import prefix: `package:sample_latest/`
- Localization files in `lib/l10n/` as ARB format, generated code via `flutter gen-l10n`
- Flavors configured at the native level (Android `build.gradle`, iOS schemes, macOS)
- Assets organized by flavor under `asset/`
