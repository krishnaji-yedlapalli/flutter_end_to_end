
// Result class for handling responses
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result.ok(this.data)
      : error = null,
        isSuccess = true;

  Result.error(this.error)
      : data = null,
        isSuccess = false;
}