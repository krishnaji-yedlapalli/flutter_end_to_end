import 'package:app_core/core/firebase/services/firebase_remote_config_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Holds local in-memory overrides and delegates all reads to [FirebaseRemoteConfigService],
/// checking overrides first. Call [notifyListeners] propagates to all widgets
/// that depend on [RemoteConfigScope].
/// This is just for debug mode, so no need to follow DI technique here.
class RemoteConfigOverrideNotifier extends ChangeNotifier {
  final _service = GetIt.I<FirebaseRemoteConfigService>();
  final Map<String, dynamic> _overrides = {};

  Map<String, dynamic> get overrides => Map.unmodifiable(_overrides);

  void setOverride(String key, dynamic value) {
    _overrides[key] = value;
    _service.setOverride(key, value);
    notifyListeners();
  }

  void clearOverride(String key) {
    _overrides.remove(key);
    _service.clearOverride(key);
    notifyListeners();
  }

  void clearAll() {
    for (final key in _overrides.keys.toList()) {
      _service.clearOverride(key);
    }
    _overrides.clear();
    notifyListeners();
  }

  String getString(String key) => _overrides.containsKey(key)
      ? _overrides[key].toString()
      : _service.getString(key);

  bool getBool(String key) => _overrides.containsKey(key)
      ? _overrides[key] as bool
      : _service.getBool(key);

  int getInt(String key) => _overrides.containsKey(key)
      ? _overrides[key] as int
      : _service.getInt(key);

  double getDouble(String key) => _overrides.containsKey(key)
      ? _overrides[key] as double
      : _service.getDouble(key);
}

/// Widgets that don't need reactivity can still use GetIt directly.
class RemoteConfigScope
    extends InheritedNotifier<RemoteConfigOverrideNotifier> {
  RemoteConfigScope({
    super.key,
    required super.child,
  }) : super(notifier: RemoteConfigOverrideNotifier());

  static RemoteConfigOverrideNotifier of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RemoteConfigScope>();
    assert(scope != null, 'No RemoteConfigScope found in widget tree');
    return scope!.notifier!;
  }
}
