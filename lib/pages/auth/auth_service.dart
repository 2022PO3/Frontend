import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';

import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus { unAuthenticated, authenticated, verified }

class AuthService {
  static bool _isHostSet(SharedPreferences pref) {
    return pref.getString('serverUrl') == null;
  }

  static Future<String> _tryLocalRequest() async {
    print(
        'Could not reach https://po3backend.ddns.net/liveliness. Redirecting to localhost.');
    try {
      http.Response response = await http.get(
        Uri.parse('http://192.168.49.1:8000/liveliness'),
      );
      print('Sending request to http://192.168.49.1:8000/liveliness.');
      if (response.statusCode == 200) {
        return 'http://192.168.49.1:8000/';
      }
    } on SocketException {
      throw Exception('No backend host found.');
    } catch (e) {
      print(e);
      throw Exception(
          'Host returned a non 200 status code to the liveliness request.');
    }
    throw Exception(
        'Host returned a non 200 status code to the liveliness request.');
  }

  static Future<String?> _determineHost(SharedPreferences pref) async {
    if (_isHostSet(pref) && !StaticValues.overrideServerUrl) {
      return null;
    }
    bool debug = StaticValues.debug;
    if (debug) {
      print('Debug enabled, redirecting to localhost.');
      return 'http://192.168.49.1:8000/';
    }
    try {
      http.Response response = await http.get(
        Uri.parse('https://po3backend.ddns.net/liveliness'),
      );
      print('Sending request to https://po3backend.ddns.net/liveliness.');
      if (response.statusCode == 200) {
        return 'https://po3backend.ddns.net/';
      }
    } on SocketException {
      _tryLocalRequest();
    } on TimeoutException {
      _tryLocalRequest();
    }
    throw Exception(
        'Host returned a non 200 status code to the liveliness request.');
  }

  static Future<void> _setServerUrl(
      SharedPreferences pref, String serverUrl) async {
    await pref.setString('serverUrl', serverUrl);
  }

  static Future<LoginStatus> checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    String? serverUrl = await _determineHost(pref);
    if (serverUrl != null) {
      AuthService._setServerUrl(pref, serverUrl);
    }
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        apiSlug: StaticValues.getUserSlug,
        useAuthToken: true,
      );
      try {
        User user = await NetworkHelper.filterResponse(
          callBack: User.userFromJson,
          response: response,
        );
        bool? twoFactorValidated = user.twoFactorValidated;
        if (user.twoFactor && twoFactorValidated != null) {
          return twoFactorValidated
              ? LoginStatus.verified
              : LoginStatus.authenticated;
        } else {
          return LoginStatus.verified;
        }
      } on BackendException catch (e) {
        print(e);
        return LoginStatus.unAuthenticated;
      }
    } on BackendException catch (e) {
      print(e);
      return LoginStatus.unAuthenticated;
    }
  }
}
