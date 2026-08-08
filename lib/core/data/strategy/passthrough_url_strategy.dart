import 'package:sample_latest/core/data/strategy/base_url_strategy.dart';

/// No-op URL strategy — returns the path unchanged.
///
/// Used for the Azure client where paths are plain REST paths
/// that don't need any transformation.
class PassthroughUrlStrategy implements BaseUrlStrategy {
  @override
  String transformPath(String path, String baseUrl) => path;
}
