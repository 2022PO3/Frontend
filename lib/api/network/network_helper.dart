// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:po_frontend/api/network/network_exception.dart';

class NetworkHelper {
  const NetworkHelper._();

  /// The Backend response will contain or the `data` field or the `errors` field in the JSON-response. The former is seen as valid response, the latter as invalid.
  static bool _isValidResponse(Map<String, dynamic>? json) {
    return json != null && json['data'] != null;
  }

  static bool validateResponse(http.Response? response) {
    bool onFailureCallBack(List<String> errors) {
      throw BackendException(errors);
    }

    try {
      if (response != null && response.statusCode == 204) {
        return true;
      }
      if (response == null || response.body.isEmpty) {
        return onFailureCallBack(['The request returned an empty response.']);
      }

      Map<String, dynamic> json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_isValidResponse(json)) {
          return true;
        } else {
          print("Backend errors: ${List<String>.from(json['errors'])}");
          return onFailureCallBack(List<String>.from(json['errors']));
        }
      } else if ([400, 401, 403].contains(response.statusCode)) {
        print("Backend errors: ${List<String>.from(json['errors'])}");
        return onFailureCallBack(List<String>.from(json['errors']));
      } else if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 1708) {
        return onFailureCallBack(['Socket exception']);
      }
      return onFailureCallBack(['An unknown error occurred.']);
    } catch (e, stackTrace) {
      print('Exception: $e');
      print(stackTrace);
      return onFailureCallBack(['Exception: $e']);
    }
  }

  static R? filterResponse<R>({
    required Function callBack,
    required http.Response? response,
  }) {
    onFailureCallBack(List<String> errors) {
      throw BackendException(errors);
    }

    try {
      if (response == null || response.body.isEmpty) {
        return onFailureCallBack(['The request returned an empty response.']);
      }
      Map<String, dynamic> json =
          jsonDecode(response.body.replaceAll('\\\\', '\\'));
      print('Response status code: ${response.statusCode}');
      print('Response: $json');
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_isValidResponse(json)) {
          return callBack(json['data']);
        } else {
          print("Backend errors: ${List<String>.from(json['errors'])}");
          return onFailureCallBack(List<String>.from(json['errors']));
        }
      } else if ([400, 401, 403].contains(response.statusCode)) {
        print("Backend errors: ${List<String>.from(json['errors'])}");
        return onFailureCallBack(List<String>.from(json['errors']));
      } else if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 1708) {
        return onFailureCallBack(['Socket exception']);
      }
      return onFailureCallBack(['An unknown error occurred.']);
    } catch (e) {
      print('Exception: $e');
      return onFailureCallBack(['Exception: $e']);
    }
  }
}
