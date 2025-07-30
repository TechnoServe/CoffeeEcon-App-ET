import 'package:dio/dio.dart';

/// Dio interceptor for adding authorization headers and handling errors.
/// This interceptor automatically adds authentication headers to all API requests
/// and provides a centralized place for error handling and request modification.
class AppInterceptors extends Interceptor {
  /// Adds the Authorization header to outgoing requests.
  /// This method is called before each request and adds the Bearer token
  /// to the Authorization header for authentication.
  /// 
  /// [options] - The request options to modify
  /// [handler] - The interceptor handler to continue the request
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Bearer token to Authorization header
    options.headers['Authorization'] = 'Bearer TOKEN';
    // Continue with the modified request
    return handler.next(options);
  }

  /// Handles errors from HTTP requests.
  /// This method is called when a request fails and provides a place
  /// to handle errors centrally before they reach the calling code.
  /// 
  /// [err] - The DioException that occurred
  /// [handler] - The interceptor handler to continue error processing
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      handler.next(err);
}
