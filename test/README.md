# Unit & Widget Tests

## Overview

This directory contains unit tests and widget tests for the Flutter End to End project. Tests verify BLoC/Cubit logic, repository implementations, use cases, and widget rendering in isolation from the full application.

## Directory Structure

```
test/
├── mock_data/          # Shared test fixtures and mock objects
├── unit_testing/       # Unit tests (BLoC, repository, use case, validators)
└── widget_testing/     # Widget tests (UI component verification)
```

## Testing Strategy

- **Unit tests**: Verify BLoC/Cubit logic, repository implementations, use cases, and utility functions in isolation
- **Widget tests**: Verify individual widget rendering and interaction behavior without a full app context
- **Mocking**: Uses `mocktail` for creating mock dependencies
- **BLoC testing**: Uses `bloc_test` for testing state transitions

## Naming Conventions

- Test files mirror source file names with a `_test.dart` suffix
- Test groups use `group()` to organize related tests
- Individual tests use descriptive `test()` / `testWidgets()` names
- Mock data files are placed in `mock_data/` and named after the data they represent

## Running Tests

```bash
# Run all unit and widget tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/unit_testing/validator_test.dart

# Run only widget tests
flutter test test/widget_testing/
```

## Related

- [Integration Tests](../integration_test/README.md)
- [Root README](../README.md)
