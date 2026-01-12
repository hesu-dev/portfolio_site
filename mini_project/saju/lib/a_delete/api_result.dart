class ApiResult<T> {
  final bool success;
  final T data;

  ApiResult({required this.success, required this.data});
}
