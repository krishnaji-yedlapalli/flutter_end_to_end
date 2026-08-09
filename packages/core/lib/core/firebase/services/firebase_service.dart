/// Base abstract class for all Firebase services.
///
/// Every Firebase service (Analytics, Crashlytics, RemoteConfig, etc.)
/// should implement this contract to ensure consistent lifecycle management.
abstract class FirebaseService {
  /// Initializes the service with any required configuration.
  Future<void> initialize();

  /// Disposes of any resources held by the service.
  Future<void> dispose();

  /// Whether the service has been successfully initialized.
  bool get isInitialized;
}
