import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

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
    callBack: User.loginUserFromJson,
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

Future<User> getUserInfo() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getUserSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: User.userFromJson,
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
