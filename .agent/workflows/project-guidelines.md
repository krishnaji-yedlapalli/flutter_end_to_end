---
description: General project guidelines and coding standards
---

# Project Guidelines for Flutter End to End

## Architecture Principles

1. **Follow Clean Architecture** - All features should follow the BLoC pattern with proper separation:
   - `data/` - Data sources, repositories, models
   - `domain/` - Entities, use cases, repository interfaces
   - `presentation/` - UI, BLoC, widgets

2. **Use Adaptive UI Components** - Always use the adaptive widgets from `lib/core/device/` for cross-platform consistency:
   - Use `AdaptiveButton`, `AdaptiveText`, `AdaptiveScaffold`, etc.
   - Leverage `ScreenBreakpoints` for responsive layouts
   - Use `DeviceConfig` for platform-specific behavior

3. **State Management** - Use BLoC for complex state, Provider for simple state

## Code Style

1. **Follow Dart conventions** - Use `dart format` and respect `analysis_options.yaml`
2. **Naming conventions**:
   - Files: `snake_case.dart`
   - Classes: `PascalCase`
   - Variables/functions: `camelCase`
   - Constants: `kConstantName` or `SCREAMING_SNAKE_CASE`

3. **Imports ordering**:
   ```dart
   // Dart imports
   import 'dart:async';
   
   // Flutter imports
   import 'package:flutter/material.dart';
   
   // Package imports
   import 'package:provider/provider.dart';
   
   // Project imports
   import 'package:sample_latest/core/...';
   ```

## Feature Development

1. **New features** should be added to `lib/features/`
2. **Shared utilities** go in `lib/shared/`
3. **Core functionality** (routing, theme, device) stays in `lib/core/`

## Testing Requirements

1. Write unit tests for business logic
2. Write widget tests for UI components
3. Update integration tests for critical user flows
4. Run tests before committing: `flutter test`

## Platform Support

- Always consider all platforms: iOS, Android, Web, macOS, Windows, Linux
- Test responsive behavior across different screen sizes
- Use platform checks when needed: `Platform.isAndroid`, `kIsWeb`, etc.

## Commit Conventions

Follow Conventional Commits for semantic releases:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/updates
- `chore:` - Maintenance tasks
