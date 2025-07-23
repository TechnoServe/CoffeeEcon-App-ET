import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// A Dio interceptor for logging and formatting HTTP requests and responses.
typedef HttpLoggerFilter = bool Function();

class HttpFormatter extends Interceptor {
  /// Creates an [HttpFormatter] with options for what to include in logs.
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
  final bool _includeRequest;
  final bool _includeRequestHeaders;
  final bool _includeRequestBody;
  final bool _includeResponse;
  final bool _includeResponseHeaders;
  final bool _includeResponseBody;

  final HttpLoggerFilter? _httpLoggerFilter;

  /// Called when a request is initiated.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra = <String, dynamic>{
      'start_time': DateTime.now().millisecondsSinceEpoch,
    };
    super.onRequest(options, handler);
  }

  /// Called when a response is received.
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (_httpLoggerFilter == null || _httpLoggerFilter!()) {
      final message = _prepareLog(response.requestOptions, response);
      if (message != '') {
        _logger.i(message);
      }
    }
    super.onResponse(response, handler);
  }

  /// Called when an error occurs during a request.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_httpLoggerFilter == null || _httpLoggerFilter!()) {
      final message = _prepareLog(err.requestOptions, err.response);
      if (message != '') {
        _logger.e(message);
      }
    }
    return super.onError(err, handler);
  }

  /// Pretty prints a JSON body or returns as a regular string.
  String _getBody(Object? data, String? contentType) {
    if (contentType != null &&
        contentType.toLowerCase().contains('application/json')) {
      const encoder = JsonEncoder.withIndent('  ');
      Map<String, dynamic> jsonBody;
      if (data is String) {
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
  String _prepareLog(
    RequestOptions requestOptions,
    Response<dynamic>? response,
  ) {
    var requestString = '';
    var responseString = '';

    if (_includeRequest) {
      requestString = '⤴ REQUEST ⤴\n\n';

      requestString += '${requestOptions.method} ${requestOptions.path}\n';

      if (_includeRequestHeaders) {
        for (final header in requestOptions.headers.entries) {
          final StringBuffer requestBuffer = StringBuffer();

          requestBuffer.write('${header.key}: ${header.value}\n');
          // Convert to a string when done
          requestString = requestBuffer.toString();
        }
      }

      if (_includeRequestBody &&
          requestOptions.data != null &&
          requestOptions.data.toString().isNotEmpty) {
        requestString +=
            '\n\n${_getBody(requestOptions.data, requestOptions.contentType)}';
      }

      requestString += '\n\n';
    }

    if (_includeResponse && response != null) {
      responseString =
          '⤵ RESPONSE [${response.statusCode}/${response.statusMessage}] '
          '${requestOptions.extra['start_time'] != null ? '[Time elapsed: ${DateTime.now().millisecondsSinceEpoch - (requestOptions.extra['start_time'] as int)} ms]' : ''}'
          '⤵\n\n';

      if (_includeResponseHeaders) {
        for (final header in response.headers.map.entries) {
          final StringBuffer requestBuffer = StringBuffer();

          requestBuffer.write('${header.key}: ${header.value}\n');
          // Convert to a string when done
          requestString = requestBuffer.toString();
        }
      }
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
