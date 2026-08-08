import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Builds a [DioCacheInterceptor] with in-memory LRU storage.
///
/// Configuration:
/// - MemCacheStore for in-memory LRU caching
/// - CachePolicy.request to follow HTTP cache directives
/// - 5-minute default TTL (maxStale)
/// - Only caches GET requests (allowPostMethod: false)
/// - Returns cached data on network failure (hitCacheOnNetworkFailure)
DioCacheInterceptor buildCacheInterceptor() {
  final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    maxStale: const Duration(minutes: 5),
    priority: CachePriority.normal,
    allowPostMethod: false,
  );

  return DioCacheInterceptor(options: cacheOptions);
}
