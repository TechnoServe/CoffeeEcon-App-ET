import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// A Dio interceptor for logging and formatting HTTP requests and responses.
/// This interceptor provides detailed logging of API requests and responses
/// for debugging and monitoring purposes.
typedef HttpLoggerFilter = bool Function();

class HttpFormatter extends Interceptor {
  /// Creates an [HttpFormatter] with options for what to include in logs.
  /// 
  /// [includeRequest] - Whether to log request details
  /// [includeRequestHeaders] - Whether to log request headers
  /// [includeRequestBody] - Whether to log request body
  /// [includeResponse] - Whether to log response details
  /// [includeResponseHeaders] - Whether to log response headers
  /// [includeResponseBody] - Whether to log response body
  /// [logger] - Custom logger instance (optional)
  /// [httpLoggerFilter] - Filter function to control when logging occurs
  HttpFormatter({
    bool includeRequest = false,
    bool includeRequestHeaders = false,
    bool includeRequestBody = false,
    bool includeResponse = false,
    bool includeResponseHeaders = false,
    bool includeResponseBody = false,
    Logger? logger,
    HttpLoggerFilter? httpLoggerFilter,
  })  : _includeRequest = includeRequest,
        _includeRequestHeaders = includeRequestHeaders,
        _includeRequestBody = includeRequestBody,
        _includeResponse = includeResponse,
        _includeResponseHeaders = includeResponseHeaders,
        _includeResponseBody = includeResponseBody,
        _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                colors: true,
                dateTimeFormat: DateTimeFormat.none,
                printEmojis: false,
              ),
            ),
        _httpLoggerFilter = httpLoggerFilter;
  
  // Logger object to pretty print the HTTP Request
  final Logger _logger;
  
  // Configuration flags for what to include in logs
  final bool _includeRequest;
  final bool _includeRequestHeaders;
  final bool _includeRequestBody;
  final bool _includeResponse;
  final bool _includeResponseHeaders;
  final bool _includeResponseBody;

  // Optional filter function to control when logging occurs
  final HttpLoggerFilter? _httpLoggerFilter;

  /// Called when a request is initiated.
  /// Records the start time for calculating request duration.
  /// 
  /// [options] - The request options
  /// [handler] - The interceptor handler
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Record start time for duration calculation
    options.extra = <String, dynamic>{
      'start_time': DateTime.now().millisecondsSinceEpoch,
    };
    super.onRequest(options, handler);
  }

  /// Called when a response is received.
  /// Logs the response details if logging is enabled.
  /// 
  /// [response] - The response received from the server
  /// [handler] - The interceptor handler
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // Check if logging should occur based on filter
    if (_httpLoggerFilter == null || _httpLoggerFilter!()) {
      final message = _prepareLog(response.requestOptions, response);
      if (message != '') {
        _logger.i(message); // Log as info level
      }
    }
    super.onResponse(response, handler);
  }

  /// Called when an error occurs during a request.
  /// Logs the error details if logging is enabled.
  /// 
  /// [err] - The DioException that occurred
  /// [handler] - The interceptor handler
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if logging should occur based on filter
    if (_httpLoggerFilter == null || _httpLoggerFilter!()) {
      final message = _prepareLog(err.requestOptions, err.response);
      if (message != '') {
        _logger.e(message); // Log as error level
      }
    }
    return super.onError(err, handler);
  }

  /// Pretty prints a JSON body or returns as a regular string.
  /// This method formats JSON data for better readability in logs.
  /// 
  /// [data] - The data to format
  /// [contentType] - The content type to determine formatting
  /// Returns formatted string representation of the data
  String _getBody(Object? data, String? contentType) {
    // Check if content type is JSON for pretty printing
    if (contentType != null &&
        contentType.toLowerCase().contains('application/json')) {
      const encoder = JsonEncoder.withIndent('  ');
      Map<String, dynamic> jsonBody;
      
      if (data is String) {
        // Parse string data as JSON
        final decodedData = jsonDecode(data);
        if (decodedData is Map<String, dynamic>) {
          jsonBody = decodedData;
        } else {
          return data.toString(); // Handle non-Map JSON types like List, etc.
        }
      } else if (data is Map<String, dynamic>) {
        jsonBody = data;
      } else {
        return data.toString(); // Return the data as a string if it's not a Map
      }

      return encoder.convert(jsonBody);
    } else {
      return data.toString();
    }
  }

  /// Extracts headers and body from the request and response for logging.
  /// This method builds the complete log message with request and response details.
  /// 
  /// [requestOptions] - The original request options
  /// [response] - The response received (can be null for errors)
  /// Returns the formatted log message
  String _prepareLog(
    RequestOptions requestOptions,
    Response<dynamic>? response,
  ) {
    var requestString = '';
    var responseString = '';

    // Build request log section if enabled
    if (_includeRequest) {
      requestString = '⤴ REQUEST ⤴\n\n';

      // Add HTTP method and path
      requestString += '${requestOptions.method} ${requestOptions.path}\n';

      // Add request headers if enabled
      if (_includeRequestHeaders) {
        for (final header in requestOptions.headers.entries) {
          final StringBuffer requestBuffer = StringBuffer();

          requestBuffer.write('${header.key}: ${header.value}\n');
          // Convert to a string when done
          requestString = requestBuffer.toString();
        }
      }

      // Add request body if enabled and present
      if (_includeRequestBody &&
          requestOptions.data != null &&
          requestOptions.data.toString().isNotEmpty) {
        requestString +=
            '\n\n${_getBody(requestOptions.data, requestOptions.contentType)}';
      }

      requestString += '\n\n';
    }

    // Build response log section if enabled
    if (_includeResponse && response != null) {
      // Calculate elapsed time if start time is available
      final elapsedTime = requestOptions.extra['start_time'] != null 
          ? DateTime.now().millisecondsSinceEpoch - (requestOptions.extra['start_time'] as int)
          : null;
      
      responseString =
          '⤵ RESPONSE [${response.statusCode}/${response.statusMessage}] '
          '${elapsedTime != null ? '[Time elapsed: $elapsedTime ms]' : ''}'
          '⤵\n\n';

      // Add response headers if enabled
      if (_includeResponseHeaders) {
        for (final header in response.headers.map.entries) {
          final StringBuffer requestBuffer = StringBuffer();

          requestBuffer.write('${header.key}: ${header.value}\n');
          // Convert to a string when done
          requestString = requestBuffer.toString();
        }
      }
      
      // Add response body if enabled and present
      if (response.data is String &&
          _includeResponseBody &&
          response.data != null) {
        final String responseData = response.data as String;
        if (responseData.isNotEmpty) {
          responseString +=
              '\n\n${_getBody(response.data, response.headers.value('content-type'))}';
        }
      }
    }

    return requestString + responseString;
  }
}
