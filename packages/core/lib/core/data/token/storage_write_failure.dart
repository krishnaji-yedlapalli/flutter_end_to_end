/// Thrown when a write or delete operation on secure token storage fails.
class StorageWriteFailure implements Exception {
  final String operation;
  final String key;
  final Object? cause;

  const StorageWriteFailure({
    required this.operation,
    required this.key,
    this.cause,
  });

  @override
  String toString() =>
      'StorageWriteFailure(operation: $operation, key: $key, cause: $cause)';
}
