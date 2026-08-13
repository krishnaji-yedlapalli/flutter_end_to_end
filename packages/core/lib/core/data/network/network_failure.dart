import 'package:app_core/core/data/utils/service_enums_typedef.dart';

/// A categorized network error that replaces raw exceptions.
class NetworkFailure {
  final DataErrorStateType type;
  final String? message;
  final bool isCancellation;

  const NetworkFailure({
    required this.type,
    this.message,
    this.isCancellation = false,
  });

  @override
  String toString() =>
      'NetworkFailure(type: $type, message: $message, isCancellation: $isCancellation)';
}
