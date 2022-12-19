// Project imports:
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<Device>> getDevices() async {
  final response = await NetworkService.sendRequest(
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
  String name,
) async {
  final response = await NetworkService.sendRequest(
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

Future<bool> deleteDevice(Device device) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.twoFactorDevicesSlug,
    useAuthToken: true,
    pk: device.id,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> disable2FA() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.disable2FASlug,
    useAuthToken: true,
  );

  return NetworkHelper.validateResponse(response);
}
