import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:po_frontend/env/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

enum RequestType { get, post, put, delete }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() => {
        'Content-Type': 'application/json',
        'PO3-ORIGIN': 'app',
        'PO3-APP-KEY': _encodeKey(),
      };

  static Future<Map<String, String>> _setAuthHeaders() async {
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
        'iat': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
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
            .timeout(const Duration(seconds: 5));
      case RequestType.post:
        return http
            .post(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 5));
      case RequestType.put:
        return http
            .put(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 5));
      case RequestType.delete:
        return http
            .delete(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 5));
    }
  }

  /// Sends a request to `url` with the given `RequestType`.
  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String apiSlug,
    required bool useAuthToken,
    int? pk,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    String url = setPk(requestType, await setServerUrl(apiSlug), body, pk);
    String queryParamsUrl = setQueryParams(requestType, url, queryParams);
    print('Sending request to $queryParamsUrl');
    try {
      final response = await createRequest(
          requestType: requestType,
          uri: Uri.parse(queryParamsUrl),
          headers: useAuthToken ? await _setAuthHeaders() : _getHeaders(),
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
  static Future<String> setServerUrl(String apiSlug) async {
    final pref = await SharedPreferences.getInstance();
    String? serverUrl = pref.getString('serverUrl');
    if (serverUrl == null) {
      return 'https://po3backend.ddns.net/$apiSlug';
    }
    return '$serverUrl$apiSlug';
  }

  /// Adds a primary key to the request url in a GET-request when a pk is given and in a
  /// PUT-request from the body that is given. If not, an error will be raised.
  static String setPk(RequestType requestType, String url,
      Map<String, dynamic>? body, int? pk) {
    if (requestType == RequestType.get && pk != null) {
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
    if (requestType == RequestType.get && queryParams != null) {
      String queryString = Uri(queryParameters: queryParams).query;
      return '$url?$queryString';
    } else {
      return url;
    }
  }
}
