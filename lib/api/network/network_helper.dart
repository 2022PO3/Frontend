import 'dart:convert';

import 'package:po_frontend/api/network/network_exception.dart';
import 'package:http/http.dart' as http;

typedef NetworkCallBack<R> = R Function(Map<String, dynamic>);

class NetworkHelper {
  const NetworkHelper._();

  /// The Backend response will contain or the `data` field or the `errors` field in the JSON-response. The former is seen as valid response, the latter as invalid.
  static bool _isValidResponse(Map<String, dynamic>? json) {
    return json != null && json['data'] != null;
  }

  static R? filterResponse<R>({
    required NetworkCallBack callBack,
    required http.Response? response,
  }) {
    R onFailureCallBack(List<String> errors) {
      throw BackendException(errors);
    }

    ;

    try {
      if (response == null || response.body.isEmpty) {
        return onFailureCallBack(['The request returned an empty response']);
      }

      Map<String, dynamic> json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_isValidResponse(json)) {
          return callBack(json['data']);
        } else {
          return onFailureCallBack(List<String>.from(json['errors']));
        }
      } else if ([400, 401, 403].contains(response.statusCode)) {
        return onFailureCallBack(List<String>.from(json['errors']));
      } else if (response.statusCode == 204) {
        return null;
      } else if (response.statusCode == 1708) {
        return onFailureCallBack(['Socket exception']);
      }
      return onFailureCallBack(['An unknown error occurred.']);
    } catch (e) {
      return onFailureCallBack(['Exception: $e']);
    }
  }
}
