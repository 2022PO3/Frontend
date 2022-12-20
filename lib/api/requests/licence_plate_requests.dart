// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<LicencePlate>> getLicencePlates(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.licencePlatesListSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.listFromJSON,
    response: response,
  );
}

Future<LicencePlate> postLicencePlate(
    BuildContext context, Map<String, dynamic> body) async {
  final response = await NetworkService.sendRequest(context,
      requestType: RequestType.post,
      apiSlug: StaticValues.licencePlatesListSlug,
      useAuthToken: true,
      body: body);

  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.fromJSON,
    response: response,
  );
}

Future<bool> deleteLicencePlate(BuildContext context, LicencePlate lp) async {
  final response = await NetworkService.sendRequest(
    context,
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
