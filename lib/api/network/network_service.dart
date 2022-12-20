// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:po_frontend/utils/server_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/env/env.dart';

enum RequestType { get, post, put, delete }

class NetworkService {
  const NetworkService._();

  static Map<String, String> getHeaders() => {
        'Content-Type': 'application/json',
        'PO3-ORIGIN': 'app',
        'PO3-APP-KEY': _encodeKey(),
      };

  static Future<Map<String, String>> setAuthHeaders() async {
    final userInfo = await SharedPreferences.getInstance();
    final authToken = userInfo.getString('authToken');
    return {
      'Content-Type': 'application/json',
      'PO3-ORIGIN': 'app',
      'PO3-APP-KEY': _encodeKey(),
      'Authorization': 'Token $authToken',
    };
  }

  /// Private method which creates a JWT-token to provide a signature for the request to
  /// the Backend. The token will only life for 5 seconds. After that, it's not longer
  /// usable.
  static String _encodeKey() {
    final jwt = JWT(
      {
        'iat': (DateTime.now()
                    .add(const Duration(seconds: -10))
                    .millisecondsSinceEpoch /
                1000)
            .round(),
        'exp': (DateTime.now()
                    .add(const Duration(seconds: 5))
                    .millisecondsSinceEpoch /
                1000)
            .round(),
        'key': Env.appSecretKey.toString()
      },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    String token = jwt.sign(SecretKey(Env.jwtSecret.toString()));
    return token;
  }

  /// Private method which creates a request based on the `RequestType` and adds the
  /// right headers.
  static Future<http.Response>? createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) async {
    switch (requestType) {
      case RequestType.get:
        return http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 15));
      case RequestType.post:
        return http
            .post(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 15));
      case RequestType.put:
        return http
            .put(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 15));
      case RequestType.delete:
        return http
            .delete(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 15));
    }
  }

  /// Sends a request to `url` with the given `RequestType`.
  static Future<http.Response?>? sendRequest(
    BuildContext context, {
    required RequestType requestType,
    required String apiSlug,
    required bool useAuthToken,
    int? pk,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    String url = setPk(requestType, _getServerUrl(context, apiSlug), body, pk);
    String queryParamsUrl = setQueryParams(requestType, url, queryParams);
    print('Sending $requestType to $queryParamsUrl');
    try {
      final response = await createRequest(
          requestType: requestType,
          uri: Uri.parse(queryParamsUrl),
          headers: useAuthToken ? await setAuthHeaders() : getHeaders(),
          body: json.encode(body));
      return response;
    } on TimeoutException catch (e) {
      throw BackendException(['Request timed out: $e']);
    } on Exception catch (e) {
      throw BackendException(['Unknown exception occurred: $e']);
    }
  }

  /// Determines the `serverUrl` from the user's device memory (this is set in the loading
  /// page). If not url is set, an error will be raised.
  static String _getServerUrl(BuildContext context, String apiSlug) {
    String serverURL = getServerURL(context);
    return '$serverURL$apiSlug';
  }

  /// Adds a primary key to the request url in a GET-request when a pk is given and in a
  /// PUT-request from the body that is given. If not, an error will be raised.
  static String setPk(RequestType requestType, String url,
      Map<String, dynamic>? body, int? pk) {
    if (url.contains('user')) {
      return url;
    } else if ((requestType == RequestType.get ||
            requestType == RequestType.post ||
            requestType == RequestType.delete) &&
        pk != null) {
      return '$url/${pk.toString()}';
    } else if (requestType == RequestType.put) {
      if (body == null) {
        throw BackendException(['A body is required for a put request.']);
      } else {
        return '$url/${body['id'].toString()}';
      }
    }
    return url;
  }

  /// Sets optional query params in a GET-request.
  static String setQueryParams(
      RequestType requestType, String url, Map<String, dynamic>? queryParams) {
    if (url.contains('user')) {
      return url;
    } else if (requestType == RequestType.get && queryParams != null) {
      String queryString = Uri(queryParameters: queryParams).query;
      return '$url?$queryString';
    } else {
      return url;
    }
  }
}
