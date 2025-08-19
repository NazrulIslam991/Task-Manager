import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:task_manager/task_manager_app.dart';
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
  static const String _defaultErrorMessege = "Somwthing Wrong!!!";
  static const String _unAuthorizedToken = "UnAuthorized token";
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        'token': AuthController.accessToken ?? '',
      };
      _logRequest(url, null, headers);

      Response response = await get(uri, headers: headers);
      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _OnUnAuthorized();
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

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? body,
    bool isFromLogin = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        'content-type': 'application/json',
        'token': AuthController.accessToken ?? '',
      };
      _logRequest(url, body, headers);
      Response response = await post(
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
        if (isFromLogin == false) {
          _OnUnAuthorized();
        }
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

  static void _logRequest(
    String url,
    Map<String, String>? body,
    Map<String, String>? headers,
  ) {
    debugPrint(
      '=======================Request start============================'
      '\n'
      'Url : $url\n'
      'Headers : $headers\n'
      'body : $body\n'
      '========================Request End============================',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint(
      '===================Respons Start================================'
      '\n'
      'Url : $url\n'
      'Status Code : ${response.statusCode}\n'
      'body : ${response.body}\n'
      '===================Respons End=================================',
    );
  }

  static Future<void> _OnUnAuthorized() async {
    await AuthController.clearData();
    Navigator.of(
      TaskManagerApp.navigator.currentContext!,
    ).pushNamedAndRemoveUntil(SignIn_page.name, (predicate) => false);
  }
}
