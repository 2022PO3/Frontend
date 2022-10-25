import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() =>
      {"Content-Type": "application/json"};

  static Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    print('Making request');
    if (requestType == RequestType.get) {
      return http.get(uri, headers: headers);
    }
  }

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      print('Sending Request');
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
