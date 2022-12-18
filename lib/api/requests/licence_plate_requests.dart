// Project imports:
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<LicencePlate>> getLicencePlates() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.licencePlatesListSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.listFromJSON,
    response: response,
  );
}

Future<LicencePlate> postLicencePlate(Map<String, dynamic> body) async {
  final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.licencePlatesListSlug,
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
    apiSlug: StaticValues.licencePlatesListSlug,
    useAuthToken: true,
    pk: lp.id,
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> uploadCertificateFile() async {
  return true;
}
