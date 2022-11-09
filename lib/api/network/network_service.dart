import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() =>
      {"Content-Type": "application/json"};

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
        return http.get(uri, headers: headers);
      case RequestType.post:
        return http.post(uri, headers: headers, body: body);
      case RequestType.put:
        return http.put(uri, headers: headers, body: body);
      case RequestType.delete:
        return http.delete(uri, headers: headers, body: body);
    }
  }

  /// Sends a request to `url` with the given `RequestType`.
  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    String? body,
  }) async {
    print("Sending request to $url");
    try {
      final response = _createRequest(
          requestType: requestType,
          uri: Uri.parse(url),
          headers: _getHeaders(),
          body: body);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
