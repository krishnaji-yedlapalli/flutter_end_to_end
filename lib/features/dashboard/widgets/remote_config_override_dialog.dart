import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_latest/core/firebase/config/remote_config_keys.dart';
import 'package:sample_latest/core/firebase/config/remote_config_scope.dart';
import 'package:sample_latest/shared/mixins/mixins.dart';

void showRemoteConfigOverrideDialog(BuildContext context) {
  final notifier = RemoteConfigScope.of(context);
  _DialogHost(context).show(notifier);
}

class _DialogHost with CustomDialogs {
  _DialogHost(this.context);
  final BuildContext context;

  void show(RemoteConfigOverrideNotifier notifier) {
    adaptiveDialog(
      context,
      dialogWithButtons(
        title: 'Remote Config Overrides',
        content: RemoteConfigOverrideContent(notifier: notifier),
        actions: const ['Close', 'Reset All'],
        callBack: (index) {
          if (index == 1) notifier.clearAll();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }
}

class RemoteConfigOverrideContent extends StatefulWidget {
  const RemoteConfigOverrideContent({super.key, required this.notifier});

  final RemoteConfigOverrideNotifier notifier;

  @override
  State<RemoteConfigOverrideContent> createState() =>
      _RemoteConfigOverrideContentState();
}

class _RemoteConfigOverrideContentState
    extends State<RemoteConfigOverrideContent> {
  late final Map<String, TextEditingController> _controllers;
  final Map<String, Timer> _debounceTimers = {};

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final key in RemoteConfigKeys.registry.keys)
        key: TextEditingController(
          text:
              widget.notifier.overrides[key]?.toString() ?? _currentValue(key),
        ),
    };
  }

  String _currentValue(String key) {
    final type = RemoteConfigKeys.registry[key];
    if (type == bool) return widget.notifier.getBool(key).toString();
    if (type == int) return widget.notifier.getInt(key).toString();
    if (type == double) return widget.notifier.getDouble(key).toString();
    return widget.notifier.getString(key);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final t in _debounceTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: RemoteConfigKeys.registry.entries.map((entry) {
          final key = entry.key;
          final type = entry.value;
          final isOverridden = widget.notifier.overrides.containsKey(key);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: type == bool
                      ? _BoolRow(
                          label: key,
                          value: isOverridden
                              ? widget.notifier.overrides[key] as bool
                              : widget.notifier.getBool(key),
                          onChanged: (v) => setState(
                              () => widget.notifier.setOverride(key, v)),
                        )
                      : TextField(
                          controller: _controllers[key],
                          decoration: InputDecoration(
                            labelText: key,
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (v) {
                            _debounceTimers[key]?.cancel();
                            _debounceTimers[key] = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                final parsed = type == int
                                    ? int.tryParse(v)
                                    : type == double
                                        ? double.tryParse(v)
                                        : v;
                                if (parsed != null) {
                                  setState(() =>
                                      widget.notifier.setOverride(key, parsed));
                                }
                              },
                            );
                          },
                        ),
                ),
                if (isOverridden)
                  IconButton(
                    icon: const Icon(Icons.restart_alt, size: 20),
                    tooltip: 'Reset',
                    onPressed: () => setState(() {
                      widget.notifier.clearOverride(key);
                      _controllers[key]?.text = _currentValue(key);
                    }),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BoolRow extends StatelessWidget {
  const _BoolRow(
      {required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch.adaptive(value: value, onChanged: onChanged),
      ],
    );
  }
}
