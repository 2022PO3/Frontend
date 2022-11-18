import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/Providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

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
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
      'serverUrl',
      'https://po3backend.ddns.net/',
    );
    try {
      await NetworkService.sendRequest(
        requestType: RequestType.get,
        apiSlug: StaticValues.getUserSlug,
        useAuthToken: true,
      );
    } on Exception {
      print(
          "Could not connect to po3backend server, redirecting to localhost.");
      await pref.setString(
        'serverUrl',
        'http://192.168.49.1:8000/',
      );
    } finally {
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
          userProvider.setUser(user);
          return redirectToHomeScreen();
        } on BackendException {
          return redirectToLoginScreen();
        }
      } on TimeoutException {
        print("Server not found.");
        return redirectToLoginScreen();
      }
    }
  }

  void redirectToHomeScreen() {
    Navigator.popAndPushNamed(context, '/home');
  }

  void redirectToLoginScreen() {
    Navigator.popAndPushNamed(context, '/login_page');
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