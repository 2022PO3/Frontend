// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/requests/opening_hours_requests.dart';
import 'package:po_frontend/api/requests/price_requests.dart';
import 'package:po_frontend/pages/garage_info.dart';

Future<Garage> getGarage(BuildContext context, int garageId) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesDetailSlug,
    useAuthToken: true,
    pk: garageId,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}

Future<GarageData> getGarageData(BuildContext context, int garageId) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesDetailSlug,
    useAuthToken: true,
    pk: garageId,
  );

  Garage garage = await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
  List<OpeningHour> openingHours = [];
  if (context.mounted) {
    openingHours = await getOpeningHours(context, garageId);
  }

  List<Price> prices = [];
  if (context.mounted) {
    prices = await getPrices(context, garageId);
  }

  return GarageData(
    garage: garage,
    openingHours: openingHours,
    prices: prices,
    garageSettings: garage.garageSettings,
  );
}

Future<List<Garage>> getGarages(BuildContext context) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesListSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.listFromJSON,
    response: response,
  );
}

Future<List<Garage>> getOwnedGarages(BuildContext context, User owner) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesDetailSlug,
    useAuthToken: true,
  );
  List<Garage> garages = await NetworkHelper.filterResponse(
    callBack: Garage.listFromJSON,
    response: response,
  );
  return garages..where((garage) => garage.userId == owner.id);
}

Future<Garage> postGarage(BuildContext context, Garage garage) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.post,
    apiSlug: StaticValues.garagesListSlug,
    useAuthToken: true,
    body: garage.toJSON(),
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}

Future<Garage> putGarage(BuildContext context, Garage garage) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.put,
    apiSlug: StaticValues.garagesDetailSlug,
    useAuthToken: true,
    body: garage.toJSON(),
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}
