import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<ParkingLot>> getParkingLots(
  int garageId,
  Map<String, String> queryParams,
) async {
  final response = await NetworkService.sendRequest(
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
  int garageId,
  Map<String, String> queryParams,
) async {
  final response = await NetworkService.sendRequest(
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
