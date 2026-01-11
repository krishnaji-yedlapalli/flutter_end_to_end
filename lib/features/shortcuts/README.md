# Enhanced Shortcuts Feature

A comprehensive keyboard shortcuts demonstration showcasing Flutter's `Shortcuts` and `Actions` APIs with adaptive platform support, inline help, and mobile fallbacks.

## Features

### ✨ Comprehensive Shortcut Support
- **Text Operations**: Copy, Paste, Select All, Undo, Redo, Clear
- **Navigation**: Tab switching with arrow keys, Ctrl+Tab, direct tab access (Ctrl+1/2/3)
- **Counter Controls**: Increment/decrement with arrow keys, multiple reset options
- **Help System**: F1 to toggle contextual help overlays

### 📱 Adaptive Platform Handling
- **Desktop/Web**: Full keyboard shortcut support
- **Mobile/Touch**: Fallback buttons for all shortcut actions
- **Cross-Platform**: Automatically adapts Cmd (macOS) vs Ctrl (Windows/Linux)

### 💡 Inline Help System
- **Contextual Help**: Each tab shows relevant shortcuts
- **Global Help**: F1 toggles help overlay on any screen
- **Visual Hints**: Keyboard-style shortcut badges
- **Mobile-Friendly**: Help button for touch devices

### 🎯 Dynamic Navigation
- **Circular Tab Navigation**: Arrow keys wrap around tabs
- **Browser-Style**: Ctrl+Tab / Ctrl+Shift+Tab for next/previous
- **Direct Access**: Ctrl+1, Ctrl+2, Ctrl+3 jump to specific tabs
- **Smart Focus**: Proper focus management throughout

## File Structure

```
lib/features/shortcuts/
├── shortcuts_main.dart          # Main tab view with global navigation
├── call_back_shortcuts.dart     # Counter demo using CallbackShortcuts
├── shortcut_actions.dart        # Text editor with Shortcuts/Actions API
└── shortcut_utils.dart          # Shared utilities and reusable components
```

## Usage Examples

### Text Editor Shortcuts (Tab 2)

```dart
// Available shortcuts:
Ctrl+A      - Select All
Ctrl+C      - Copy selected text
Ctrl+V      - Paste from clipboard
Ctrl+Z      - Undo last change
Ctrl+Y      - Redo
Ctrl+Backspace - Clear all text
F1          - Toggle help overlay
```

### Counter Controls (Tab 1)

```dart
// Available shortcuts:
↑           - Increment counter
↓           - Decrement counter
Ctrl+Backspace - Reset to zero
Ctrl+C      - Clear (alternative)
R           - Quick reset
F1          - Toggle help
```

### Global Navigation

```dart
// Available shortcuts:
←/→         - Navigate between tabs
Ctrl+Tab    - Next tab (circular)
Ctrl+Shift+Tab - Previous tab (circular)
Ctrl+1/2/3  - Jump to specific tab
F1          - Toggle global help
```

## Implementation Details

### Shortcuts vs CallbackShortcuts

**CallbackShortcuts** (Tab 1):
- Simpler API for basic shortcuts
- Direct callback execution
- Good for simple state updates
- Example: Counter increment/decrement

**Shortcuts + Actions** (Tab 2):
- More powerful and flexible
- Separates intent from action
- Better for complex operations
- Supports async operations
- Example: Text editing with clipboard

### Adaptive Platform Support

The feature uses `DeviceConfiguration` to detect platform capabilities:

```dart
// Show mobile buttons on touch devices
if (DeviceConfiguration.isMobileResolution) {
  _buildMobileButtons()
}

// Adapt modifier keys for platform
final modifier = Platform.isMacOS 
    ? LogicalKeyboardKey.meta  // Cmd
    : LogicalKeyboardKey.control; // Ctrl
```

### Undo/Redo Implementation

Simple history-based undo/redo:
- Maintains a history stack (max 50 entries)
- Tracks current position in history
- Ctrl+Z moves backward, Ctrl+Y moves forward
- Automatically adds to history on clear operations

## Mobile Experience

On mobile devices (detected via `DeviceConfiguration.isMobileResolution`):
- Shortcut buttons appear below text fields
- Help toggle button in app bar
- Tab navigation buttons between tabs
- All keyboard shortcuts remain functional with external keyboards

## Extending the Feature

### Adding New Shortcuts

1. **Define Intent**:
```dart
class MyCustomIntent extends Intent {
  const MyCustomIntent();
}
```

2. **Create Action**:
```dart
class MyCustomAction extends Action<MyCustomIntent> {
  @override
  void invoke(covariant MyCustomIntent intent) {
    // Your action logic
  }
}
```

3. **Register Shortcut**:
```dart
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyM): 
        const MyCustomIntent(),
  },
  child: Actions(
    actions: {
      MyCustomIntent: MyCustomAction(),
    },
    child: YourWidget(),
  ),
)
```

### Adding Help Hints

Use the reusable `ShortcutHint` widget:

```dart
ShortcutHint('Ctrl+M', 'My custom action')
```

Or create a help overlay:

```dart
ShortcutHelpOverlay(
  title: 'My Feature Shortcuts',
  shortcuts: [
    ShortcutHint('Ctrl+M', 'Custom action'),
    ShortcutHint('Ctrl+N', 'Another action'),
  ],
  onClose: () => setState(() => _showHelp = false),
)
```

## Testing

The shortcuts feature works across all platforms:
- **Web**: Full keyboard support in Chrome, Firefox, Safari
- **Desktop**: Native keyboard handling on macOS, Windows, Linux
- **Mobile**: Touch buttons + external keyboard support on iOS/Android

## Best Practices

1. **Always provide mobile alternatives**: Don't rely solely on keyboard shortcuts
2. **Show help prominently**: Users need to discover available shortcuts
3. **Use standard conventions**: Ctrl+C for copy, Ctrl+V for paste, etc.
4. **Handle focus properly**: Ensure shortcuts work when widgets are focused
5. **Avoid conflicts**: Check for existing shortcuts before adding new ones
6. **Platform adaptation**: Use Cmd on macOS, Ctrl elsewhere

## Known Limitations

- Undo/Redo history is simple (no branching)
- Some shortcuts may conflict with browser/OS shortcuts
- Mobile keyboard shortcuts require external keyboard
- History is not persisted across app restarts

## Future Enhancements

- [ ] Customizable shortcuts (user preferences)
- [ ] Shortcut conflict detection
- [ ] Advanced undo/redo with branching
- [ ] Shortcut recording/macro system
- [ ] Persistent history across sessions
- [ ] More text formatting shortcuts (bold, italic, etc.)
- [ ] Search functionality with Ctrl+F
- [ ] Command palette (Ctrl+P style)

## References

- [Flutter Shortcuts Documentation](https://api.flutter.dev/flutter/widgets/Shortcuts-class.html)
- [Flutter Actions Documentation](https://api.flutter.dev/flutter/widgets/Actions-class.html)
- [CallbackShortcuts Documentation](https://api.flutter.dev/flutter/widgets/CallbackShortcuts-class.html)
