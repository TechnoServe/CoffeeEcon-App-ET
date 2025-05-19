import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add tokens, headers here
    options.headers['Authorization'] = 'Bearer TOKEN';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      handler.next(err);
}
