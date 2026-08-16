# Routing Feature

Demonstrates advanced GoRouter navigation patterns including ShellRoute (nested navigation with a persistent shell), StatefulShellRoute with IndexedStack branching, and declarative parent-child route hierarchies.

## Overview

The Routing Feature is a self-contained showcase of GoRouter's navigation capabilities beyond simple `go()` and `push()` calls. It provides a dashboard that lets users explore different routing strategies, each illustrating how to structure nested navigation while preserving shared UI elements (app bars, scaffolds) across child routes.

Key concepts demonstrated:

- **ShellRoute** — wraps child routes in a persistent scaffold so the app bar and navigation chrome remain stable while only the body content changes between parent/child screens
- **StatefulShellRoute with IndexedStack** — uses `StatefulNavigationShell` and `goBranch()` to switch between indexed branches (tabs/segments) while preserving each branch's state
- **Provider scoping within ShellRoutes** — declares `ChangeNotifierProvider` at the shell level so all child routes share the same state instance without wrapping the entire app
- **Declarative path-based navigation** — uses `context.go()` and `context.push()` for programmatic navigation within nested route trees
- **Parent-child route hierarchies** — models multi-level navigation (parent → child1 → child2 → child3) under a single ShellRoute

## Directory Structure

```
routing_feature/
├── lib/
│   ├── dynamic_routing_configuration.dart         # Placeholder for dynamic route config
│   ├── route_dashboard.dart                       # Dashboard grid listing routing demos
│   ├── state_ful_shell_routing_with_indexed.dart  # StatefulShellRoute + IndexedStack demo
│   ├── stateful_shell_routing_without_indexed.dart # StatefulShellRoute without index (WIP)
│   └── shell_route/
│       ├── shell_routing.dart                     # ShellRoute wrapper scaffold
│       └── shell_child_one/
│           ├── shell_parent.dart                  # Parent route with Provider counter
│           ├── shell_child_one.dart               # Child 1 — navigates to Child 2
│           ├── shell_child_two.dart               # Child 2 — navigates to Child 3
│           └── shell_child_three.dart             # Child 3 — deepest nested route
└── pubspec.yaml
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `go_router` | Declarative routing with ShellRoute and StatefulShellRoute support |
| `provider` | State management scoped to ShellRoute for shared state across child routes |
| `app_core` | Device configuration and shared enum/type definitions |

## Platform Support

| Platform | Supported |
|----------|-----------|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| macOS    | ✅ |
| Linux    | ✅ |
| Windows  | ✅ |

## Usage

### Navigating to the Routing Dashboard

The feature is accessible from the app's home screen. The full path is:

```
https://flutter-end-to-end.web.app/home/route
```

The routing feature is accessible from the app's home screen. It presents a grid of available routing demos:

```dart
// From the home router, navigate to the routing dashboard
context.go('/home/route');
```

### ShellRoute Demo (Parent → Children)

Navigate into the ShellRoute demo to see persistent app-bar navigation with child body swapping:

```dart
// Navigate to shell route parent
context.go('/home/route/parent');

// Navigate deeper into child routes (body changes, shell stays)
context.go('/home/route/parent/child1');
context.push('/home/route/parent/child1/child2');
```

### StatefulShellRoute with IndexedStack

Switch between indexed branches using a `SegmentedButton`. Each branch preserves its own widget state:

```dart
// Navigate to the stateful shell route
context.go('/home/route/stateFullShellRoutingWithIndexed/hi');

// Switch branches programmatically
navigationShell.goBranch(index);
```

### Provider Scoping in Shell Routes

The ShellRoute wrapper declares a `ChangeNotifierProvider` at the shell level. All child routes inherit and share this provider without any global setup:

```dart
// In shell_routing.dart — provider scoped to the shell
ChangeNotifierProvider(
  create: (context) => RouteProvider(),
  child: Scaffold(
    appBar: ...,
    body: widget, // child route content
  ),
);

// In any child route — read/watch shared state
context.watch<RouteProvider>().value;
context.read<RouteProvider>().increase();
```

## References

- [Root README](../../README.md)
- [Core Package](../../packages/core/README.md)
- [GoRouter documentation](https://pub.dev/packages/go_router)
