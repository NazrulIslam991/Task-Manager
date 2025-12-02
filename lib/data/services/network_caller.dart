import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // <- Use prefix to avoid conflict
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';

class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final Map<String, dynamic>? body;
  final String? errorMessege;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.body,
    this.errorMessege,
  });
}

class NetworkCaller {
  static const String _defaultErrorMessege = "Something went wrong!";
  static const String _unAuthorizedToken = "Unauthorized token";

  /// GET Request
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {'token': AuthController.accessToken ?? ''};

      _logRequest(url, null, headers);

      http.Response response = await http.get(uri, headers: headers);

      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        await _onUnAuthorized();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessege: _unAuthorizedToken,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessege: decodedJson['data'] ?? _defaultErrorMessege,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessege: e.toString(),
        statusCode: -1,
      );
    }
  }

  /// POST Request
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? body,
    bool isFromLogin = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {
        'content-type': 'application/json',
        'token': AuthController.accessToken ?? '',
      };

      _logRequest(url, body, headers);

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        if (!isFromLogin) await _onUnAuthorized();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessege: _unAuthorizedToken,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessege: decodedJson['data'] ?? _defaultErrorMessege,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessege: e.toString(),
        statusCode: -1,
      );
    }
  }

  /// Logging request
  static void _logRequest(
    String url,
    Map<String, String>? body,
    Map<String, String>? headers,
  ) {
    debugPrint(
      '=======================Request start============================\n'
      'Url : $url\n'
      'Headers : $headers\n'
      'Body : $body\n'
      '========================Request End============================',
    );
  }

  /// Logging response
  static void _logResponse(String url, http.Response response) {
    debugPrint(
      '===================Response Start===============================\n'
      'Url : $url\n'
      'Status Code : ${response.statusCode}\n'
      'Body : ${response.body}\n'
      '===================Response End=================================',
    );
  }

  /// Handle Unauthorized
  static Future<void> _onUnAuthorized() async {
    await AuthController.clearData();
    Get.offAllNamed(SignIn_page.name);
  }
}
