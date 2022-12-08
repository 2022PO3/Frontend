import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/providers/user_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  static const String route = 'loading-screen';

  final String? email;
  final String? password;

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  /// Checks the accessToken of the user stored in memory to see if it's valid or not. If the
  /// `accessToken` is valid, the user will be redirected to the `HomeScreen`, otherwise to the
  /// `LoginScreen`.
  /// Furthermore it sets the `serverUrl` for the application, which serves as a back-up in case
  /// of the po3server failing.
  Future<void> checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    String? serverUrl = await determineHost(pref);
    if (serverUrl != null) {
      await setServerUrl(pref, serverUrl);
    }
    await redirectUser();
  }

  void redirectToHomeScreen() {
    Navigator.pushReplacementNamed(context, 'home');
  }

  void redirectToLoginScreen() {
    Navigator.pushReplacementNamed(context, 'login');
  }

  void redirectToTwoFactorScreen() {
    Navigator.pushReplacementNamed(context, '/two-factor');
  }

  Future<void> setServerUrl(SharedPreferences pref, String serverUrl) async {
    await pref.setString('serverUrl', serverUrl);
  }

  bool isHostSet(SharedPreferences pref) {
    return pref.getString('serverUrl') == null;
  }

  Future<String?> determineHost(SharedPreferences pref) async {
    if (isHostSet(pref)) {
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
      }
    }
    throw Exception(
        'Host returned a non 200 status code to the liveliness request.');
  }

  Future<void> redirectUser() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
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
        if (user.twoFactor) {
          return redirectToTwoFactorScreen();
        } else {
          userProvider.setUser(user);
          return redirectToHomeScreen();
        }
      } on BackendException {
        return redirectToLoginScreen();
      }
    } on BackendException catch (e) {
      print(e);
      return redirectToLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Boys'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
