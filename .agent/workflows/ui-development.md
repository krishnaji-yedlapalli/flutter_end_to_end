---
description: How to build adaptive and responsive UIs in this project
---

# UI Development Guide

This project emphasizes a "Design Once, Run Anywhere" philosophy using custom adaptive components.

## Core Adaptive Tools

Located in `lib/core/device/`:
- **`config/`**: `DeviceConfiguration` handles platform detection (isWeb, isMobile, etc.) and global styling tokens.
- **`widgets/`**: Contains `AdaptiveButton`, `AdaptiveText`, `AdaptiveScaffold`, etc. These automatically switch between Material and Cupertino designs.
- **`utils/`**: `ScreenBreakpoints` helps define layout changes for mobile, tablet, and desktop.

## Best Practices for AI Agents

1. **Prefer Adaptive Widgets**: Do not use `ElevatedButton` or `CupertinoButton` directly unless necessary. Use `AdaptiveButton` (or feature-specific buttons in `lib/shared/widgets/responsive_widgets/`).
2. **Handle Screen Sizes**: Use `DeviceConfiguration.isMobileResolution` or `DeviceConfiguration.isTabletResolution` to switch layouts.
3. **Platform Check**: Use `DeviceConfiguration.operatingSystemType` instead of `Platform.isAndroid/iOS` when possible to maintain web compatibility.
4. **Style Tokens**: Reference `DeviceConfiguration.platformBorderRadius` and `DeviceConfiguration.platformElevation` for consistency.

## Example: Responsive Layout

```dart
Widget build(BuildContext context) {
  if (DeviceConfiguration.isMobileResolution) {
    return MobileLayout();
  } else {
    return DesktopLayout();
  }
}
```
