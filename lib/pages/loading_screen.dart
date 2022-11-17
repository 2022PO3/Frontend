import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/Providers/user_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin().then(
      (bool loggedIn) {
        if (loggedIn) {
          redirectToHomeScreen();
        } else {
          redirectToLoginScreen();
        }
      },
    );
  }

  Future<bool> checkLogin() async {
    // This functions checks the accessToken, uid and client of the user stored in memory to see if it's valid or not.
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      url: StaticValues.baseUrl + StaticValues.getUserSlug,
      useAuthToken: true,
    );
    try {
      User user = await NetworkHelper.filterResponse(
        callBack: User.userFromJson,
        response: response,
      );
      userProvider.setUser(user);
      return true;
    } on BackendException {
      return false;
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
