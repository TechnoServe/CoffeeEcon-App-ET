import 'package:dio/dio.dart';

/// Dio interceptor for adding authorization headers and handling errors.
class AppInterceptors extends Interceptor {
  /// Adds the Authorization header to outgoing requests.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer TOKEN';
    return handler.next(options);
  }

  /// Handles errors from HTTP requests.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      handler.next(err);
}
