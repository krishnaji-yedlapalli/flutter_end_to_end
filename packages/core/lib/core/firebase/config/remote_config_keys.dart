/// Centralised registry of Firebase Remote Config keys.
///
/// Usage:
/// ```dart
/// final value = GetIt.I<FirebaseRemoteConfigService>()
///     .getBool(RemoteConfigKeys.newFeatureEnabled);
/// ```
class RemoteConfigKeys {
  const RemoteConfigKeys._();

  // App Title Label
  static const String appTitleLabel = 'app_title_label';
  static const String automaticKeepAliveFeatureEnabled =
      'automaticKeepAliveFeatureEnabled';

  // App Update
  static const String minSupportedOsVersionAndroid =
      'min_supported_sdk_version_android';
  static const String minSupportedOsVersionIos = 'min_supported_os_version_ios';
  static const String minSupportedOsVersionMacos =
      'min_supported_os_version_macos';
  static const String minSupportedOsVersionWeb = 'min_supported_os_version_web';
  static const String minSupportedAppVersion = 'min_supported_app_version';
  static const String latestAppVersion = 'latest_app_version';
  static const String appUpdateUrl = 'app_update_url';

  /// Maps each key to its expected [Type] for the override dialog UI.
  static const Map<String, Type> registry = {
    appTitleLabel: String,
    automaticKeepAliveFeatureEnabled: bool,
    minSupportedOsVersionAndroid: String,
    minSupportedOsVersionIos: String,
    minSupportedOsVersionMacos: String,
    minSupportedAppVersion: String,
    minSupportedOsVersionWeb: String,
    latestAppVersion: String,
    appUpdateUrl: String,
  };
}
