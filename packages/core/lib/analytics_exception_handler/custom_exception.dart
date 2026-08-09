class OfflineException implements Exception {
  final Object? error;

  final StackTrace? stackTrace;

  OfflineException({this.error, this.stackTrace});
}
