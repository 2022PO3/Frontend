import 'package:po_frontend/api/models/garage_settings_model.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/pages/garage_info.dart';

import '../models/garage_model.dart';
import '../models/parking_lot_model.dart';
import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<Garage> getGarage(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageSlug,
    useAuthToken: true,
    pk: garageId,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}

Future<Garage> updateGarage(Garage garage) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.getGarageSlug,
    useAuthToken: true,
    body: garage.toJSON(),
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}

Future<List<Garage>> getAllGarages() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGaragesSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.listFromJSON,
    response: response,
  );
}

Future<List<Price>> getGaragePrices(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGaragePricesSlug,
    useAuthToken: true,
    pk: garageId,
  );
  return await NetworkHelper.filterResponse(
      callBack: Price.listFromJSON, response: response);
}

Future<GarageSettings> getGarageSettings(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageSettingsSlug,
    useAuthToken: true,
    pk: garageId,
  );

  return await NetworkHelper.filterResponse(
      callBack: GarageSettings.fromJSON, response: response);
}

Future<List<OpeningHour>> getGarageOpeningHours(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageOpeningHoursSlug,
    useAuthToken: true,
    pk: garageId,
  );
  return await NetworkHelper.filterResponse(
      callBack: OpeningHourListFromJson, response: response);
}

Future<GarageData> getGarageData(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageSlug,
    useAuthToken: true,
    pk: garageId,
  );

  Garage garage = await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );

  List<OpeningHour> openingHours = await getGarageOpeningHours(garageId);
  List<Price> prices = await getGaragePrices(garageId);
  GarageSettings garageSettings = await getGarageSettings(garageId);

  return GarageData(
    garage: garage,
    openingHours: openingHours,
    prices: prices,
    garageSettings: garageSettings,
  );
}

Future<List<ParkingLot>> getGarageParkingLots(
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

Future<List<Garage>> getOwnedGarages(User owner) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getOwnedGaragesSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.listFromJSON,
    response: response,
  );
}
