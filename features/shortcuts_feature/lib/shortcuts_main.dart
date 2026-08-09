import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/device/enums/device_enums.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:app_core/shared/widgets/responsive_widgets/adaptive_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortcuts_feature/call_back_shortcuts.dart';
import 'package:shortcuts_feature/shortcut_actions.dart';

class ShortcutsTabView extends StatefulWidget {
  const ShortcutsTabView({Key? key}) : super(key: key);

  @override
  State<ShortcutsTabView> createState() => _ShortcutsTabViewState();
}

class _ShortcutsTabViewState extends State<ShortcutsTabView>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;
  bool _showGlobalHelp = false;

  final List<Tab> tabs = const [
    Tab(text: 'Callback Shortcuts'),
    Tab(text: 'Text Editor'),
    Tab(text: 'Navigation Demo'),
  ];

  @override
  initState() {
    tabCtrl = TabController(length: tabs.length, vsync: this);
    tabCtrl.addListener(() {
      setState(() {}); // Rebuild when tab changes to update navigation demo
    });
    super.initState();
  }

  bool get _isMobilePlatform {
    final osType = DeviceConfiguration.operatingSystemType;
    return osType == OperatingSystemType.android ||
        osType == OperatingSystemType.ios;
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Tab navigation
        LogicalKeySet(LogicalKeyboardKey.arrowRight):
            const TabChangeRightIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft):
            const TabChangeLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
            const TabChangeRightIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
            LogicalKeyboardKey.tab): const TabChangeLeftIntent(),
        // Direct tab access
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1):
            const TabChangeDirectIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2):
            const TabChangeDirectIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3):
            const TabChangeDirectIntent(2),
        // Global help
        LogicalKeySet(LogicalKeyboardKey.f1): const ToggleGlobalHelpIntent(),
      },
      child: Actions(
        actions: <Type, Action>{
          TabChangeRightIntent: TabChangeRightAction(tabCtrl),
          TabChangeLeftIntent: TabChangeLeftAction(tabCtrl),
          TabChangeDirectIntent: TabChangeDirectAction(tabCtrl),
          ToggleGlobalHelpIntent: ToggleGlobalHelpAction(
              () => setState(() => _showGlobalHelp = !_showGlobalHelp)),
        },
        child: Scaffold(
          appBar: CustomAppBar(
            appBar: AppBar(),
            title: const Text('Enhanced Shortcuts Demo'),
            actions: [
              if (_isMobilePlatform)
                IconButton(
                  icon: Icon(_showGlobalHelp ? Icons.help : Icons.help_outline),
                  onPressed: () =>
                      setState(() => _showGlobalHelp = !_showGlobalHelp),
                ),
            ],
          ),
          body: Column(
            children: [
              if (_showGlobalHelp) _buildGlobalHelpOverlay(),
              TabBar(
                controller: tabCtrl,
                isScrollable: true,
                tabs: tabs,
              ),
              if (_isMobilePlatform) _buildMobileTabNavigation(),
              Expanded(
                child: TabBarView(
                  controller: tabCtrl,
                  children: [
                    const CallBackShortCutsView(),
                    const ShortcutActions(),
                    _buildNavigationDemo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalHelpOverlay() {
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
          Text('Global Navigation Shortcuts:',
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
              _ShortcutHint('←/→', 'Navigate Tabs'),
              _ShortcutHint('Ctrl+Tab', 'Next Tab'),
              _ShortcutHint('Ctrl+Shift+Tab', 'Previous Tab'),
              _ShortcutHint('Ctrl+1/2/3', 'Direct Tab Access'),
              _ShortcutHint('F1', 'Toggle Help'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabNavigation() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AdaptiveButton(
            text: '← Previous',
            onPressed: tabCtrl.index > 0
                ? () => Actions.invoke(context, const TabChangeLeftIntent())
                : null,
            isPrimary: false,
          ),
          AdaptiveButton(
            text: 'Next →',
            onPressed: tabCtrl.index < tabs.length - 1
                ? () => Actions.invoke(context, const TabChangeRightIntent())
                : null,
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDemo() {
    return Focus(
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Navigation Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Navigation Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Tab: ${tabCtrl.index + 1} of ${tabs.length}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Tab Name: "${tabs[tabCtrl.index].text}"',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (tabCtrl.index + 1) / tabs.length,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!_isMobilePlatform) ...[
              Text(
                'Try These Navigation Shortcuts:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _ShortcutHint('← →', 'Navigate between tabs'),
                  _ShortcutHint('Ctrl+Tab', 'Next tab (circular)'),
                  _ShortcutHint('Ctrl+Shift+Tab', 'Previous tab (circular)'),
                  _ShortcutHint('Ctrl+1', 'Jump to Callback Shortcuts'),
                  _ShortcutHint('Ctrl+2', 'Jump to Text Editor'),
                  _ShortcutHint('Ctrl+3', 'Jump to Navigation Demo'),
                  _ShortcutHint('F1', 'Toggle global help'),
                ],
              ),
              const SizedBox(height: 24),
            ],
            if (_isMobilePlatform) ...[
              Text(
                'Touch Navigation:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Use the buttons below to navigate between tabs and see real-time updates.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AdaptiveButton(
                    text: 'Tab 1',
                    onPressed: () => tabCtrl.animateTo(0),
                    isPrimary: tabCtrl.index == 0,
                  ),
                  AdaptiveButton(
                    text: 'Tab 2',
                    onPressed: () => tabCtrl.animateTo(1),
                    isPrimary: tabCtrl.index == 1,
                  ),
                  AdaptiveButton(
                    text: 'Tab 3',
                    onPressed: () => tabCtrl.animateTo(2),
                    isPrimary: tabCtrl.index == 2,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Navigation Test Area',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This area demonstrates navigation. On desktop/web, use keyboard shortcuts. On mobile, use the touch buttons above.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    if (!_isMobilePlatform)
                      Text(
                        'Tip: Click here first, then use keyboard shortcuts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      )
                    else
                      Text(
                        'Tip: Tap the navigation buttons above to see live updates',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
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

// Navigation Intents
class TabChangeRightIntent extends Intent {
  const TabChangeRightIntent();
}

class TabChangeLeftIntent extends Intent {
  const TabChangeLeftIntent();
}

class TabChangeDirectIntent extends Intent {
  final int tabIndex;
  const TabChangeDirectIntent(this.tabIndex);
}

class ToggleGlobalHelpIntent extends Intent {
  const ToggleGlobalHelpIntent();
}

// Navigation Actions
class TabChangeRightAction extends Action<TabChangeRightIntent> {
  TabChangeRightAction(this.tabController);
  final TabController tabController;

  @override
  Object? invoke(covariant TabChangeRightIntent intent) {
    final nextIndex = (tabController.index + 1) % tabController.length;
    tabController.animateTo(nextIndex);
    return null;
  }
}

class TabChangeLeftAction extends Action<TabChangeLeftIntent> {
  TabChangeLeftAction(this.tabController);
  final TabController tabController;

  @override
  Object? invoke(TabChangeLeftIntent intent) {
    final prevIndex = tabController.index == 0
        ? tabController.length - 1
        : tabController.index - 1;
    tabController.animateTo(prevIndex);
    return null;
  }
}

class TabChangeDirectAction extends Action<TabChangeDirectIntent> {
  TabChangeDirectAction(this.tabController);
  final TabController tabController;

  @override
  Object? invoke(covariant TabChangeDirectIntent intent) {
    if (intent.tabIndex >= 0 && intent.tabIndex < tabController.length) {
      tabController.animateTo(intent.tabIndex);
    }
    return null;
  }
}

class ToggleGlobalHelpAction extends Action<ToggleGlobalHelpIntent> {
  ToggleGlobalHelpAction(this.onToggle);
  final VoidCallback onToggle;

  @override
  Object? invoke(covariant ToggleGlobalHelpIntent intent) {
    onToggle();
    return null;
  }
}
