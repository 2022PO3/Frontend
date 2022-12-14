// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

enum LoginStatus { unAuthenticated, authenticated, verified }

class AuthService {
  static bool _override(SharedPreferences pref) {
    return pref.getBool('override') ?? false;
  }

  static Future<String> _tryLocalRequest() async {
    print(
      'Could not reach https://po3backend.ddns.net/liveliness. Redirecting to localhost.',
    );
    try {
      http.Response response = await http.get(
        Uri.parse('${StaticValues.localURL}/liveliness'),
      );
      print('Sending request to ${StaticValues.localURL}/liveliness.');
      if (response.statusCode == 200) {
        return StaticValues.localURL;
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

  static Future<String> _determineHost(SharedPreferences pref) async {
    if (_override(pref)) {
      return pref.getString('localServerURL') ??
          (throw Exception('Override enabled, but no localhost specified.'));
    }
    bool debug = StaticValues.debug;
    if (debug) {
      print('Debug enabled, redirecting to localhost.');
      return StaticValues.localURL;
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
      'Host returned a non 200 status code to the liveliness request.',
    );
  }

  static Future<void> setServerURL(
    SharedPreferences pref,
    String serverURL,
  ) async {
    if (serverURL.contains('po3backend')) {
      await pref.setString('serverUrl', serverURL);
    } else {
      await pref.setString('serverUrl', serverURL);
    }
  }

  static Future<LoginStatus> checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    String serverUrl = await _determineHost(pref);
    try {
      final response = await _sendRequest(
        serverURL: serverUrl,
        requestType: RequestType.get,
        apiSlug: StaticValues.userSlug,
        useAuthToken: true,
      );
      try {
        User user = await NetworkHelper.filterResponse(
          callBack: User.fromJSON,
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

  static Future<http.Response?>? _sendRequest({
    required String serverURL,
    required RequestType requestType,
    required String apiSlug,
    required bool useAuthToken,
  }) async {
    String url = _getURL(serverURL, apiSlug);
    print('Sending $requestType to $url');
    try {
      final response = await NetworkService.createRequest(
        requestType: requestType,
        uri: Uri.parse(url),
        headers: useAuthToken
            ? await NetworkService.setAuthHeaders()
            : NetworkService.getHeaders(),
      );
      return response;
    } on TimeoutException catch (e) {
      throw BackendException(['Request timed out: $e']);
    } on Exception catch (e) {
      throw BackendException(['Unknown exception occurred: $e']);
    }
  }

  static String _getURL(String serverURL, String apiSlug) {
    return '$serverURL$apiSlug';
  }
}
