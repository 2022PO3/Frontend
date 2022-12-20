// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<Reservation>> getReservations(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.reservationsListSlug,
    useAuthToken: true,
  );

  return await NetworkHelper.filterResponse(
    callBack: Reservation.listFromJSON,
    response: response,
  );
}

Future<bool> postReservation(
  BuildContext context,
  Reservation reservation,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.post,
    apiSlug: StaticValues.reservationsListSlug,
    useAuthToken: true,
    body: reservation.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}
