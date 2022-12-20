// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<ParkingLot>> getParkingLots(
  BuildContext context,
  int garageId,
  Map<String, String> queryParams,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.getParkingLotsSlug,
    useAuthToken: true,
    pk: garageId,
    queryParams: queryParams,
  );

  return await NetworkHelper.filterResponse(
    callBack: ParkingLot.listFromJSON,
    response: response,
  );
}

Future<ParkingLot> assignParkingLot(
  BuildContext context,
  int garageId,
  Map<String, String> queryParams,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.assignParkingLotSlug,
    useAuthToken: true,
    pk: garageId,
    queryParams: queryParams,
  );

  return await NetworkHelper.filterResponse(
    callBack: ParkingLot.fromJSON,
    response: response,
  );
}
