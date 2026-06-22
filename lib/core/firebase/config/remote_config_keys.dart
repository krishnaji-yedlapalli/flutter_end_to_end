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
}
