import 'package:sample_latest/core/firebase/services/firebase_service.dart';

/// Abstract contract for Firebase Remote Config.
///
/// Provides feature flags and remote configuration values.
abstract class FirebaseRemoteConfigService extends FirebaseService {
  /// Fetches and activates the latest remote config values.
  Future<bool> fetchAndActivate();

  /// Gets a string value for the given key.
  String getString(String key);

  /// Gets a boolean value for the given key.
  bool getBool(String key);

  /// Gets an integer value for the given key.
  int getInt(String key);

  /// Gets a double value for the given key.
  double getDouble(String key);

  /// Gets all remote config values as a map.
  Map<String, dynamic> getAll();

  /// Sets the minimum fetch interval for throttling.
  Future<void> setConfigSettings({
    Duration? fetchTimeout,
    Duration? minimumFetchInterval,
  });

  /// Sets default values for remote config parameters.
  Future<void> setDefaults(Map<String, dynamic> defaults);
}
