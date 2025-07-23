import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/network/api_interceport.dart';
import 'package:flutter_template/app/core/network/http_formatter.dart';
import 'package:flutter_template/app/utils/env_loader.dart';

/// Factory for creating and configuring Dio API clients.
class ApiClient {
  /// Private constructor to prevent instantiation.
  ApiClient._(); // Prevents instantiation

  /// Creates and configures a Dio instance for API requests.
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AppInterceptors());
    dio.interceptors.add(
      HttpFormatter(
        includeRequest: true,
        includeRequestHeaders: true,
        includeRequestBody: true,
        includeResponse: true,
        includeResponseHeaders: false,
        includeResponseBody: true,
      ),
    );

    return dio;
  }
}
