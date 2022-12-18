// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/utils/user_data.dart';

Future<bool> register(
  String email,
  String password,
  String confirmPassword,
  String? firstName,
  String? lastName,
) async {
  Map<String, dynamic> body = {
    'email': email,
    'password': password,
    'passwordConfirmation': confirmPassword,
    'role': 1,
    'firstName': firstName == '' ? null : firstName,
    'lastName': lastName == '' ? null : lastName,
  };
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.postRegisterUser,
    body: body,
    useAuthToken: false,
  );
  return NetworkHelper.validateResponse(response);
}

Future<User> login(
  BuildContext context,
  String emailUser,
  String passwordUser,
) async {
  Map<String, dynamic> body = {
    'email': emailUser,
    'password': passwordUser,
  };
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.postLoginUser,
    body: body,
    useAuthToken: false,
  );
  // Contains a list of the format [User, String].
  List userResponse = await NetworkHelper.filterResponse(
    callBack: User.loginFromJSON,
    response: response,
  );

  // Store the authToken in the Shared Preferences.
  final pref = await SharedPreferences.getInstance();
  await pref.setString('authToken', userResponse[1]);

  // Store the user model in the Provider.
  User user = userResponse[0];
  setUser(context, user);

  return user;
}

Future<bool> sendAuthenticationCode(String code) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: '${StaticValues.sendAuthenticationCodeSlug}/$code',
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<void> logOut(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.postLogoutUser,
    useAuthToken: true,
  );
  if (NetworkHelper.validateResponse(response)) {
    final userInfo = await SharedPreferences.getInstance();
    userInfo.remove('authToken');
  }
  // Make sure to redirect the user.
  context.go('/login');
}
