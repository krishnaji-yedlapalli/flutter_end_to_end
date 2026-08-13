/// A typed wrapper around raw HTTP response data.
class NetworkResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, List<String>> headers;

  const NetworkResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}
