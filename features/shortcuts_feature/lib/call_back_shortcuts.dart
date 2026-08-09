import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:app_core/shared/mixins/mixins.dart';
import 'package:app_core/shared/widgets/responsive_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallBackShortCutsView extends StatefulWidget {
  const CallBackShortCutsView({Key? key}) : super(key: key);

  @override
  State<CallBackShortCutsView> createState() => _CallBackShortCutsViewState();
}

class _CallBackShortCutsViewState extends State<CallBackShortCutsView>
    with HelperWidget {
  var i = 0;
  bool _showHelp = false;

  bool get _isMobilePlatform {
    final osType = DeviceConfiguration.operatingSystemType;
    return osType == OperatingSystemType.android ||
        osType == OperatingSystemType.ios;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <SingleActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          setState(() {
            i++;
          });
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          setState(() {
            i--;
          });
        },
        const SingleActivator(LogicalKeyboardKey.backspace, control: true): () {
          setState(() {
            i = 0;
          });
        },
        const SingleActivator(LogicalKeyboardKey.f1): () {
          setState(() {
            _showHelp = !_showHelp;
          });
        },
      },
      child: CallbackShortcuts(
        bindings: <CharacterActivator, VoidCallback>{
          const CharacterActivator('c', control: true): () {
            setState(() {
              i = 0;
            });
          },
          const CharacterActivator('r'): () {
            setState(() {
              i = 0;
            });
          },
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_showHelp) _buildHelpOverlay(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Counter Control Demo',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Count: $i',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 32),
                      if (!_showHelp) ...[
                        Text(
                          'Use keyboard shortcuts to control the counter',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        const Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _ShortcutHint('↑', 'Increment'),
                            _ShortcutHint('↓', 'Decrement'),
                            _ShortcutHint('Ctrl+Backspace', 'Reset'),
                            _ShortcutHint('Ctrl+C', 'Clear'),
                            _ShortcutHint('R', 'Reset'),
                            _ShortcutHint('F1', 'Toggle Help'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (_isMobilePlatform) _buildMobileControls(),
                    ],
                  ),
                ),
              ),
              const Focus(
                autofocus: true,
                canRequestFocus: true,
                child: SizedBox(
                  height: 1,
                  width: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOverlay() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Shortcuts:',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (_isMobilePlatform)
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
                ),
              ),
              AdaptiveButton(
                text: 'Close (F1)',
                onPressed: () => setState(() => _showHelp = false),
                isPrimary: false,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _ShortcutHint('↑ Arrow', 'Increment counter by 1'),
              _ShortcutHint('↓ Arrow', 'Decrement counter by 1'),
              _ShortcutHint('Ctrl+Backspace', 'Reset counter to 0'),
              _ShortcutHint('Ctrl+C', 'Clear counter (alternative)'),
              _ShortcutHint('R', 'Quick reset to 0'),
              _ShortcutHint('F1', 'Toggle this help overlay'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileControls() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AdaptiveButton(
          text: '+ Increment',
          onPressed: () => setState(() => i++),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: '- Decrement',
          onPressed: () => setState(() => i--),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: 'Reset',
          onPressed: () => setState(() => i = 0),
          isPrimary: false,
        ),
        AdaptiveButton(
          text: _showHelp ? 'Hide Help' : 'Show Help',
          onPressed: () => setState(() => _showHelp = !_showHelp),
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
        Flexible(
          child:
              Text(description, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
