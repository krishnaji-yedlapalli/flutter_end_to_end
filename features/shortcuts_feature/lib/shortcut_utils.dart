import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_core/core/device/config/device_configurations.dart';

/// Utility class for managing keyboard shortcuts across platforms
class ShortcutUtils {
  /// Returns the appropriate modifier key based on platform
  static LogicalKeyboardKey get primaryModifier {
    if (DeviceConfiguration.operatingSystemType.toString().contains('macos')) {
      return LogicalKeyboardKey.meta; // Cmd key on macOS
    }
    return LogicalKeyboardKey.control; // Ctrl key on other platforms
  }

  /// Creates a platform-appropriate shortcut key set
  static LogicalKeySet createShortcut(LogicalKeyboardKey key,
      {bool useModifier = true}) {
    if (useModifier) {
      return LogicalKeySet(primaryModifier, key);
    }
    return LogicalKeySet(key);
  }

  /// Returns user-friendly shortcut text for display
  static String getShortcutText(LogicalKeyboardKey key,
      {bool useModifier = true}) {
    final modifierText =
        DeviceConfiguration.operatingSystemType.toString().contains('macos')
            ? 'Cmd'
            : 'Ctrl';

    final keyText = _getKeyDisplayName(key);

    if (useModifier) {
      return '$modifierText+$keyText';
    }
    return keyText;
  }

  static String _getKeyDisplayName(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.keyA) return 'A';
    if (key == LogicalKeyboardKey.keyC) return 'C';
    if (key == LogicalKeyboardKey.keyV) return 'V';
    if (key == LogicalKeyboardKey.keyZ) return 'Z';
    if (key == LogicalKeyboardKey.keyY) return 'Y';
    if (key == LogicalKeyboardKey.backspace) return 'Backspace';
    if (key == LogicalKeyboardKey.f1) return 'F1';
    if (key == LogicalKeyboardKey.tab) return 'Tab';
    if (key == LogicalKeyboardKey.arrowUp) return '↑';
    if (key == LogicalKeyboardKey.arrowDown) return '↓';
    if (key == LogicalKeyboardKey.arrowLeft) return '←';
    if (key == LogicalKeyboardKey.arrowRight) return '→';
    if (key == LogicalKeyboardKey.digit1) return '1';
    if (key == LogicalKeyboardKey.digit2) return '2';
    if (key == LogicalKeyboardKey.digit3) return '3';
    return key.keyLabel;
  }
}

/// Reusable shortcut hint widget
class ShortcutHint extends StatelessWidget {
  final String shortcut;
  final String description;
  final bool isCompact;

  const ShortcutHint(
    this.shortcut,
    this.description, {
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 4 : 6,
            vertical: isCompact ? 1 : 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Text(
            shortcut,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: isCompact ? 10 : null,
                ),
          ),
        ),
        SizedBox(width: isCompact ? 2 : 4),
        Flexible(
          child: Text(
            description,
            style: isCompact
                ? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)
                : Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Help overlay widget for displaying shortcuts
class ShortcutHelpOverlay extends StatelessWidget {
  final String title;
  final List<ShortcutHint> shortcuts;
  final VoidCallback? onClose;
  final bool showCloseButton;

  const ShortcutHelpOverlay({
    Key? key,
    required this.title,
    required this.shortcuts,
    this.onClose,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (showCloseButton && onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  iconSize: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: shortcuts,
          ),
        ],
      ),
    );
  }
}
