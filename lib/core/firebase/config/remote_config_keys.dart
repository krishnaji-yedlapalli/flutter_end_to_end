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

  /// Maps each key to its expected [Type] for the override dialog UI.
  static const Map<String, Type> registry = {
    appTitleLabel: String,
    automaticKeepAliveFeatureEnabled: bool,
  };
}
