import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:po_frontend/env/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

enum RequestType { get, post, put, delete }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() => {
        "Content-Type": "application/json",
        "PO3-ORIGIN": "app",
        "PO3-APP-KEY": encodeKey(),
      };

  static Future<Map<String, String>> _setAuthHeaders() async {
    final userInfo = await SharedPreferences.getInstance();
    final authToken = userInfo.getString('authToken');
    return {
      "Content-Type": "application/json",
      "PO3-ORIGIN": "app",
      "PO3-APP-KEY": encodeKey(),
      "Authorization": "Token $authToken",
    };
  }

  /// Private method which creates a JWT-token to provide a signature for the request to
  /// the Backend. The token will only life for 5 seconds. After that, it's not longer
  /// usable.
  static String encodeKey() {
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
      issuer: "https://github.com/jonasroussel/dart_jsonwebtoken",
    );
    String token = jwt.sign(SecretKey(Env.jwtSecret.toString()));
    return token;
  }

  /// Private method which creates a request based on the `RequestType` and adds the
  /// right headers.
  static Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    switch (requestType) {
      case RequestType.get:
        return http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 3));
      case RequestType.post:
        return http
            .post(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 3));
      case RequestType.put:
        return http
            .put(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 3));
      case RequestType.delete:
        return http
            .delete(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 3));
    }
  }

  /// Sends a request to `url` with the given `RequestType`.
  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String apiSlug,
    required bool useAuthToken,
    String? body,
  }) async {
    final pref = await SharedPreferences.getInstance();
    String? serverUrl = pref.getString("serverUrl");
    String requestUrl = "$serverUrl$apiSlug";
    print("Sending request to $requestUrl");
    try {
      final response = _createRequest(
          requestType: requestType,
          uri: Uri.parse(requestUrl),
          headers: useAuthToken ? await _setAuthHeaders() : _getHeaders(),
          body: body);
      return response;
    } catch (e) {
      print("Response error $e");
      return null;
    }
  }
}
