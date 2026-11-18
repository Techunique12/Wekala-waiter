import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wekala_waiter/api/api_checker.dart';
import 'package:wekala_waiter/core/models/error_response.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;

  static const String noInternetMessage = 'no_internet_connection';
  static const String timeoutMessage = 'connection_timeout';
  static const String unexpectedErrorMessage = 'something_went_wrong';

  final int timeoutInSeconds = 30;

  String? token;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);

    debugPrint('Token: $token');

    updateHeader(token);
  }

  void updateHeader(String? token) {
    _mainHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri, {
    bool handleError = true,
    bool showError = true,
  }) async {
    try {
      debugPrint(
        '====> API Call: $uri\n'
        'Header: $_mainHeaders',
      );

      final http.Response response = await http
          .get(Uri.parse(appBaseUrl + uri), headers: _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      debugPrint(
        '====> API Response: '
        '[${response.statusCode}] $uri',
      );

      return handleResponse(response, uri, handleError, showError);
    } on SocketException catch (e, stackTrace) {
      return _handleNetworkError(e, stackTrace, uri, handleError, showError);
    } on TimeoutException catch (e, stackTrace) {
      return _handleTimeoutError(e, stackTrace, uri, handleError, showError);
    } catch (e, stackTrace) {
      return _handleUnexpectedError(e, stackTrace, uri, handleError, showError);
    }
  }

  Future<Response> postData(
    String uri,
    dynamic body, {
    bool handleError = true,
    bool showError = true,
  }) async {
    try {
      debugPrint(
        '====> API Call: $uri\n'
        'Header: $_mainHeaders',
      );

      debugPrint('====> API Body: $body');

      debugPrint('===check=> API Body: ${body.runtimeType}');

      final http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      debugPrint(
        '====> API Response: '
        '[${response.statusCode}] $uri',
      );

      debugPrint('====> API Response Body: ${response.body}');

      return handleResponse(response, uri, handleError, showError);
    } on SocketException catch (e, stackTrace) {
      return _handleNetworkError(e, stackTrace, uri, handleError, showError);
    } on TimeoutException catch (e, stackTrace) {
      return _handleTimeoutError(e, stackTrace, uri, handleError, showError);
    } catch (e, stackTrace) {
      return _handleUnexpectedError(e, stackTrace, uri, handleError, showError);
    }
  }

  Future<Response> putData(
    String uri,
    dynamic body, {
    bool handleError = true,
    bool showError = true,
  }) async {
    try {
      debugPrint(
        '====> API Call: $uri\n'
        'Header: $_mainHeaders',
      );

      debugPrint('====> API Body: $body');

      final http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      debugPrint(
        '====> API Response: '
        '[${response.statusCode}] $uri',
      );

      debugPrint('====> API Response Body: ${response.body}');

      return handleResponse(response, uri, handleError, showError);
    } on SocketException catch (e, stackTrace) {
      return _handleNetworkError(e, stackTrace, uri, handleError, showError);
    } on TimeoutException catch (e, stackTrace) {
      return _handleTimeoutError(e, stackTrace, uri, handleError, showError);
    } catch (e, stackTrace) {
      return _handleUnexpectedError(e, stackTrace, uri, handleError, showError);
    }
  }

  Future<Response> deleteData(
    String uri, {
    bool handleError = true,
    bool showError = true,
  }) async {
    try {
      debugPrint(
        '====> API Call: $uri\n'
        'Header: $_mainHeaders',
      );

      final http.Response response = await http
          .delete(Uri.parse(appBaseUrl + uri), headers: _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      debugPrint(
        '====> API Response: '
        '[${response.statusCode}] $uri',
      );

      debugPrint('====> API Response Body: ${response.body}');

      return handleResponse(response, uri, handleError, showError);
    } on SocketException catch (e, stackTrace) {
      return _handleNetworkError(e, stackTrace, uri, handleError, showError);
    } on TimeoutException catch (e, stackTrace) {
      return _handleTimeoutError(e, stackTrace, uri, handleError, showError);
    } catch (e, stackTrace) {
      return _handleUnexpectedError(e, stackTrace, uri, handleError, showError);
    }
  }

  Response _handleNetworkError(
    Object error,
    StackTrace stackTrace,
    String uri,
    bool handleError,
    bool showError,
  ) {
    debugPrint('❌ NETWORK ERROR');
    debugPrint('URI: $uri');

    final Response response = const Response(
      statusCode: 0,
      statusText: noInternetMessage,
    );

    if (handleError) {
      ApiChecker.checkApi(response, showError: showError);
    }

    return response;
  }

  Response _handleTimeoutError(
    Object error,
    StackTrace stackTrace,
    String uri,
    bool handleError,
    bool showError,
  ) {
    final Response response = const Response(
      statusCode: -1,
      statusText: timeoutMessage,
    );

    if (handleError) {
      ApiChecker.checkApi(response, showError: showError);
    }

    return response;
  }

  Response _handleUnexpectedError(
    Object error,
    StackTrace stackTrace,
    String uri,
    bool handleError,
    bool showError,
  ) {
    final Response response = const Response(
      statusCode: -2,
      statusText: unexpectedErrorMessage,
    );

    if (handleError) {
      ApiChecker.checkApi(response, showError: showError);
    }

    return response;
  }

  Response handleResponse(
    http.Response response,
    String uri,
    bool handleError,
    bool showError,
  ) {
    dynamic body;

    try {
      if (response.body.isNotEmpty) {
        body = jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('JSON Decode Error: $e');
    }

    final Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body,
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    final int statusCode = response0.statusCode ?? 0;

    final bool isSuccess = statusCode >= 200 && statusCode < 300;

    Response finalResponse = response0;

    // API Error Response
    if (!isSuccess && response0.body != null && response0.body is! String) {
      final String bodyString = response0.body.toString();

      // Laravel style:
      // {errors: [{code: ..., message: ...}]}

      if (bodyString.startsWith('{errors: [{code:')) {
        try {
          final ErrorResponse errorResponse = ErrorResponse.fromJson(
            response0.body,
          );

          finalResponse = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.message
                : response0.statusText,
          );
        } catch (e) {
          debugPrint('ErrorResponse parsing failed: $e');
        }
      }
      // {message: ...}
      else if (bodyString.startsWith('{message')) {
        finalResponse = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText:
              response0.body['message']?.toString() ?? response0.statusText,
        );
      }
    }

    log(
      '====> API Response: '
      '[${finalResponse.statusCode}] $uri\n'
      '${finalResponse.body}',
    );

    if (handleError && !isSuccess) {
      ApiChecker.checkApi(finalResponse, showError: showError);
    }

    return finalResponse;
  }
}
