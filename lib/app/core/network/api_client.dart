import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/network/api_interceport.dart';
import 'package:flutter_template/app/core/network/http_formatter.dart';
import 'package:flutter_template/app/utils/env_loader.dart';

/// Factory for creating and configuring Dio API clients.
/// This class provides a centralized way to create configured Dio instances
/// with proper interceptors, timeouts, and base configuration for API requests.
class ApiClient {
  /// Private constructor to prevent instantiation.
  /// This class is designed to be used as a static utility class.
  ApiClient._(); // Prevents instantiation

  /// Creates and configures a Dio instance for API requests.
  /// This method sets up a Dio client with proper base URL, timeouts,
  /// headers, and interceptors for logging and error handling.
  /// 
  /// Returns a configured Dio instance ready for API requests
  static Dio createDio() {
    // Create Dio instance with base configuration
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl, // Get base URL from environment
        connectTimeout: const Duration(seconds: 10), // Connection timeout
        receiveTimeout: const Duration(seconds: 10), // Response timeout
        headers: {
          'Accept': 'application/json', // Accept JSON responses
        },
      ),
    );

    // Add custom interceptors for request/response handling
    dio.interceptors.add(AppInterceptors());
    // Add HTTP formatter for logging and debugging
    dio.interceptors.add(
      HttpFormatter(
        includeRequest: true, // Log request details
        includeRequestHeaders: true, // Log request headers
        includeRequestBody: true, // Log request body
        includeResponse: true, // Log response details
        includeResponseHeaders: false, // Don't log response headers
        includeResponseBody: true, // Log response body
      ),
    );

    return dio;
  }
}
