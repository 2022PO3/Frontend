import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<ParkingLot>> getGarageParkingLots(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getParkingLotsSlug,
    useAuthToken: true,
    pk: garageId,
  );

  return await NetworkHelper.filterResponse(
    callBack: ParkingLot.listFromJSON,
    response: response,
  );
}
