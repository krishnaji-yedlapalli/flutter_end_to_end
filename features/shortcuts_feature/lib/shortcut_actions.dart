import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:ui_kit/widgets/responsive_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutActions extends StatefulWidget {
  const ShortcutActions({Key? key}) : super(key: key);

  @override
  State<ShortcutActions> createState() => _ShortcutActionsState();
}

class _ShortcutActionsState extends State<ShortcutActions> {
  final controller = TextEditingController(
      text:
          'Hello world! Try Ctrl+A to select all, Ctrl+C to copy, Ctrl+V to paste, or Ctrl+Z to undo.');
  final focusNode = FocusNode();
  bool _showHelp = false;

  bool get _isMobilePlatform {
    final osType = DeviceConfiguration.operatingSystemType;
    return osType == OperatingSystemType.android ||
        osType == OperatingSystemType.ios;
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
            const SelectAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
            const CopyIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV):
            const PasteIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ):
            const UndoIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY):
            const RedoIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.backspace):
            const ClearAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.f1): const ToggleHelpIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SelectAllIntent: SelectAllAction(controller),
          CopyIntent: CopyAction(controller),
          PasteIntent: PasteAction(controller),
          UndoIntent: UndoAction(controller),
          RedoIntent: RedoAction(controller),
          ClearAllIntent: ClearAllAction(controller),
          ToggleHelpIntent:
              ToggleHelpAction(() => setState(() => _showHelp = !_showHelp)),
        },
        child: Column(
          children: [
            if (_showHelp) _buildHelpOverlay(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Editor with Shortcuts',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type here and use keyboard shortcuts...',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isMobilePlatform) _buildMobileButtons(),
                    Row(
                      children: [
                        AdaptiveButton(
                          text: _showHelp ? 'Hide Help (F1)' : 'Show Help (F1)',
                          onPressed: () =>
                              setState(() => _showHelp = !_showHelp),
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOverlay() {
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
          Text('Available Shortcuts:',
              style: Theme.of(context).textTheme.titleMedium),
          if (_isMobilePlatform) ...[
            const SizedBox(height: 4),
            Text(
              '(For devices with keyboards - desktops, web)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
          const SizedBox(height: 8),
          const Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _ShortcutHint('Ctrl+A', 'Select All'),
              _ShortcutHint('Ctrl+C', 'Copy'),
              _ShortcutHint('Ctrl+V', 'Paste'),
              _ShortcutHint('Ctrl+Z', 'Undo'),
              _ShortcutHint('Ctrl+Y', 'Redo'),
              _ShortcutHint('Ctrl+Backspace', 'Clear All'),
              _ShortcutHint('F1', 'Toggle Help'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AdaptiveButton(
          text: 'Select All',
          onPressed: () => Actions.invoke(context, const SelectAllIntent()),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: 'Copy',
          onPressed: () => Actions.invoke(context, const CopyIntent()),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: 'Paste',
          onPressed: () => Actions.invoke(context, const PasteIntent()),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: 'Clear',
          onPressed: () => Actions.invoke(context, const ClearAllIntent()),
          isPrimary: false,
        ),
      ],
    );
  }
}

class _ShortcutHint extends StatelessWidget {
  final String shortcut;
  final String description;

  const _ShortcutHint(this.shortcut, this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Text(
            shortcut,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
        ),
        const SizedBox(width: 4),
        Text(description, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

// Text Operation Intents
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

class CopyIntent extends Intent {
  const CopyIntent();
}

class PasteIntent extends Intent {
  const PasteIntent();
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class ClearAllIntent extends Intent {
  const ClearAllIntent();
}

class ToggleHelpIntent extends Intent {
  const ToggleHelpIntent();
}

// Text Operation Actions
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.controller);
  final TextEditingController controller;

  @override
  void invoke(covariant SelectAllIntent intent) {
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }
}

class CopyAction extends Action<CopyIntent> {
  CopyAction(this.controller);
  final TextEditingController controller;

  @override
  void invoke(covariant CopyIntent intent) {
    final selection = controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText =
          controller.text.substring(selection.start, selection.end);
      Clipboard.setData(ClipboardData(text: selectedText));
    }
  }
}

class PasteAction extends Action<PasteIntent> {
  PasteAction(this.controller);
  final TextEditingController controller;

  @override
  void invoke(covariant PasteIntent intent) async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text != null) {
      final selection = controller.selection;
      final newText = controller.text.replaceRange(
        selection.start,
        selection.end,
        clipboardData!.text!,
      );
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + clipboardData.text!.length,
        ),
      );
    }
  }
}

class UndoAction extends Action<UndoIntent> {
  UndoAction(this.controller);
  final TextEditingController controller;
  static final List<String> _history = [];
  static int _historyIndex = -1;

  @override
  void invoke(covariant UndoIntent intent) {
    if (_history.isNotEmpty && _historyIndex > 0) {
      _historyIndex--;
      controller.text = _history[_historyIndex];
    }
  }

  static void addToHistory(String text) {
    if (_history.isEmpty || _history.last != text) {
      _history.add(text);
      _historyIndex = _history.length - 1;
      if (_history.length > 50) {
        _history.removeAt(0);
        _historyIndex--;
      }
    }
  }
}

class RedoAction extends Action<RedoIntent> {
  RedoAction(this.controller);
  final TextEditingController controller;

  @override
  void invoke(covariant RedoIntent intent) {
    final history = UndoAction._history;
    var historyIndex = UndoAction._historyIndex;
    if (history.isNotEmpty && historyIndex < history.length - 1) {
      historyIndex++;
      UndoAction._historyIndex = historyIndex;
      controller.text = history[historyIndex];
    }
  }
}

class ClearAllAction extends Action<ClearAllIntent> {
  ClearAllAction(this.controller);
  final TextEditingController controller;

  @override
  void invoke(covariant ClearAllIntent intent) {
    UndoAction.addToHistory(controller.text);
    controller.clear();
  }
}

class ToggleHelpAction extends Action<ToggleHelpIntent> {
  ToggleHelpAction(this.onToggle);
  final VoidCallback onToggle;

  @override
  void invoke(covariant ToggleHelpIntent intent) {
    onToggle();
  }
}
