// api_response.dart
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  ApiResponse({
    this.data,
    this.error,
    this.isLoading = false,
  });

  ApiResponse.loading()
      : data = null,
        error = null,
        isLoading = true;

  ApiResponse.success(T? data)
      : data = data,
        error = null,
        isLoading = false;

  ApiResponse.error(String? error)
      : data = null,
        error = error,
        isLoading = false;
}