import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:po_frontend/api/models/credit_card_model.dart';
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:po_frontend/utils/notifications.dart';
import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<User> getUser() async {
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

Future<User> putUser(User user) async {
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

Future<bool> putPassword(
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

Future<bool> putAutomaticPayment(CreditCard card) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.stripeConnectionSlug,
    body: card.toJSON(),
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> deleteAutomaticPayment() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.stripeConnectionSlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}
