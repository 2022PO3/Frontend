import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<bool> registerUser(
    String emailUser,
    String passwordUser,
    String confirmPasswordUser,
    String? firstNameUser,
    String? lastNameUser) async {
  Map<String, dynamic> body = {
    'email': emailUser,
    'password': passwordUser,
    'passwordConfirmation': confirmPasswordUser,
    'role': 1,
    'firstName': firstNameUser == '' ? null : firstNameUser,
    'lastName': lastNameUser == '' ? null : lastNameUser,
  };
  print(body);
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.postRegisterUser,
    body: body,
    useAuthToken: false,
  );
  return NetworkHelper.validateResponse(response);
}

Future<User> loginUser(
    BuildContext context, String emailUser, String passwordUser) async {
  Map<String, dynamic> body = {
    'email': emailUser,
    'password': passwordUser,
  };
  print(body);
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
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(user);

  return user;
}

Future<void> logOutUser(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.postLogoutUser,
    useAuthToken: true,
  );
  if (NetworkHelper.validateResponse(response)) {
    final userInfo = await SharedPreferences.getInstance();
    userInfo.remove('authToken');
  }
  // Make sure to redirect to user.
  context.go('/login');
}

Future<User> getUserInfo() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.userSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: User.fromJSON,
    response: response,
  );
}

Future<List<Reservation>> getReservations() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getReservationSlug,
    useAuthToken: true,
  );

  return await NetworkHelper.filterResponse(
    callBack: Reservation.listFromJSON,
    response: response,
  );
}

Future<bool> disable2FA() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.disable2FASlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> postReservation(Reservation reservation) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.getReservationSlug,
    useAuthToken: true,
    body: reservation.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}

Future<User> updateUser(User user) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.userSlug,
    useAuthToken: true,
    body: user.toJSON(),
  );

  return NetworkHelper.filterResponse(
    callBack: User.fromJSON,
    response: response,
  );
}

Future<bool> deleteUser() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.userSlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> setUserPassword(
  String oldPassword,
  String newPassword,
  String passwordConfirmation,
) async {
  Map<String, dynamic> body = {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
    'passwordConfirmation': passwordConfirmation,
  };
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.changePassword,
    body: body,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> removeDevice(Device device) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.twoFactorDevicesSlug,
    useAuthToken: true,
    pk: device.id,
  );

  return NetworkHelper.validateResponse(response);
}
