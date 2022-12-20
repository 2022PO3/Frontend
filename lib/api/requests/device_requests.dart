// Project imports:
import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<Device>> getDevices(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.twoFactorDevicesSlug,
    useAuthToken: true,
  );

  return await NetworkHelper.filterResponse(
    callBack: Device.listFromJSON,
    response: response,
  );
}

Future<String> postDevice(
  BuildContext context,
  String name,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.post,
    apiSlug: StaticValues.totpListSlug,
    useAuthToken: true,
    body: {'name': name},
  );

  return await NetworkHelper.filterResponse(
    callBack: User.extractSecret,
    response: response,
  );
}

Future<bool> deleteDevice(BuildContext context, Device device) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.delete,
    apiSlug: StaticValues.twoFactorDevicesSlug,
    useAuthToken: true,
    pk: device.id,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> disable2FA(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.post,
    apiSlug: StaticValues.disable2FASlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}
