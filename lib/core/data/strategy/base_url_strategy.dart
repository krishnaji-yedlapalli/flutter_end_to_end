/// Strategy for transforming request paths based on the active base URL.
abstract class BaseUrlStrategy {
  /// Transforms [path] based on the [baseUrl] configuration.
  String transformPath(String path, String baseUrl);
}
