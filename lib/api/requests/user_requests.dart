// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:po_frontend/api/models/credit_card_model.dart';
import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<User> getUser(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.userSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: User.fromJSON,
    response: response,
  );
}

Future<User> putUser(BuildContext context, User user) async {
  final response = await NetworkService.sendRequest(
    context,
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

Future<bool> deleteUser(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.delete,
    apiSlug: StaticValues.userSlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> putPassword(
  BuildContext context,
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
    context,
    requestType: RequestType.put,
    apiSlug: StaticValues.changePasswordSlug,
    body: body,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> putAutomaticPayment(BuildContext context, CreditCard card) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.post,
    apiSlug: StaticValues.stripeConnectionSlug,
    body: card.toJSON(),
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> deleteAutomaticPayment(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.delete,
    apiSlug: StaticValues.stripeConnectionSlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}
