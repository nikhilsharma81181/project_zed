class ApiResponse<T> {
  final bool success;
  final T? payload;
  final String? errorMessage;

  ApiResponse.success()
      : success = true,
        errorMessage = null,
        payload = null;

  ApiResponse.payload(this.payload)
      : success = false,
        errorMessage = "";

  ApiResponse.error(this.errorMessage)
      : success = false,
        payload = null;

  ApiResponse.apiError()
      : success = false,
        payload = null,
        errorMessage = "Error From API";

  ApiResponse.empty()
      : success = false,
        payload = null,
        errorMessage = null;
}
