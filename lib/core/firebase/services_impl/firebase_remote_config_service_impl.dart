import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sample_latest/core/firebase/services/firebase_remote_config_service.dart';

/// Concrete implementation of [FirebaseRemoteConfigService].
class FirebaseRemoteConfigServiceImpl extends FirebaseRemoteConfigService {
  FirebaseRemoteConfigServiceImpl();

  late final FirebaseRemoteConfig _remoteConfig;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<bool> fetchAndActivate() async {
    if (!_isInitialized) return false;
    return await _remoteConfig.fetchAndActivate();
  }

  @override
  String getString(String key) {
    if (!_isInitialized) return '';
    return _remoteConfig.getString(key);
  }

  @override
  bool getBool(String key) {
    if (!_isInitialized) return false;
    return _remoteConfig.getBool(key);
  }

  @override
  int getInt(String key) {
    if (!_isInitialized) return 0;
    return _remoteConfig.getInt(key);
  }

  @override
  double getDouble(String key) {
    if (!_isInitialized) return 0.0;
    return _remoteConfig.getDouble(key);
  }

  @override
  Map<String, dynamic> getAll() {
    if (!_isInitialized) return {};
    return _remoteConfig.getAll().map(
          (key, value) => MapEntry(key, value.asString()),
        );
  }

  @override
  Future<void> setConfigSettings({
    Duration? fetchTimeout,
    Duration? minimumFetchInterval,
  }) async {
    if (!_isInitialized) return;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: fetchTimeout ?? const Duration(minutes: 1),
      minimumFetchInterval: minimumFetchInterval ?? const Duration(hours: 1),
    ));
  }

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    if (!_isInitialized) return;
    await _remoteConfig.setDefaults(defaults);
  }
}
