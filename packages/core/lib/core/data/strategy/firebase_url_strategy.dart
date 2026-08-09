import 'package:app_core/core/data/strategy/base_url_strategy.dart';

/// Appends `.json` suffix for Firebase Realtime Database URLs.
class FirebaseUrlStrategy implements BaseUrlStrategy {
  @override
  String transformPath(String path, String baseUrl) {
    if (!baseUrl.contains('firebaseio.com')) return path;
    if (path.endsWith('.json')) return path;
    return '$path.json';
  }
}
