import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/network_enums.dart';
import 'package:po_frontend/api/network/network_typedef.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  const NetworkHelper._();

  /// The Backend response will contain or the `data` field or the `errors` field in the JSON-response. The former is seen as valid response, the latter as invalid.
  static bool _isValidResponse(json) {
    return json != null && json['data'] != null;
  }

  static R filterResponse<R>({
    required NetworkCallBack callBack,
    required http.Response? response,
    required NetworkOnFailureCallBackWithMessage onFailureCallBackWithMessage,
  }) {
    try {
      if (response == null || response.body.isEmpty) {
        return onFailureCallBackWithMessage(
            NetworkResponseErrorType.responseEmpty, 'Empty response');
      }

      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (_isValidResponse(json)) {
          return callBack(json['data']);
        } else {
          return onFailureCallBackWithMessage(
              NetworkResponseErrorType.serverSideError,
              "An exception on the server happened with the following error message ${json['errors']}");
        }
      } else if (response.statusCode == 1708) {
        return onFailureCallBackWithMessage(
            NetworkResponseErrorType.socket, 'Socket exception');
      }
      return onFailureCallBackWithMessage(
          NetworkResponseErrorType.didNotSucceed, 'An unknown error occurred.');
    } catch (e) {
      return onFailureCallBackWithMessage(
          NetworkResponseErrorType.exception, 'Exception: $e');
    }
  }
}
