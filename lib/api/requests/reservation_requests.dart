// Project imports:
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<Reservation>> getReservations() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.reservationListSlug,
    useAuthToken: true,
  );

  return await NetworkHelper.filterResponse(
    callBack: Reservation.listFromJSON,
    response: response,
  );
}

Future<bool> postReservation(Reservation reservation) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.reservationListSlug,
    useAuthToken: true,
    body: reservation.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> putReservation(Reservation reservation) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.reservationDetailSlug,
    useAuthToken: true,
    pk: reservation.id,
    body: reservation.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}

