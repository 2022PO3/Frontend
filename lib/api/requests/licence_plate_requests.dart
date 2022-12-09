import '../models/licence_plate_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<List<LicencePlate>> getLicencePlates() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.licenceplatesSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.listFromJSON,
    response: response,
  );
}

Future<LicencePlate> addLicencePlate(Map<String, dynamic> body) async {
  final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.licenceplatesSlug,
      useAuthToken: true,
      body: body);

  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.fromJSON,
    response: response,
  );
}

Future<bool> deleteLicencePlate(LicencePlate lp) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.licenceplatesSlug,
    useAuthToken: true,
    pk: lp.id,
  );

  return NetworkHelper.validateResponse(response);
}
