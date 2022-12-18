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

Future<Garage> getGarage(int garageId) async {
  final response = await NetworkService.sendRequest(
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

Future<GarageData> getGarageData(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesDetailSlug,
    useAuthToken: true,
    pk: garageId,
  );

  Garage garage = await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );

  List<OpeningHour> openingHours = await getOpeningHours(garageId);
  List<Price> prices = await getPrices(garageId);

  return GarageData(
    garage: garage,
    openingHours: openingHours,
    prices: prices,
    garageSettings: garage.garageSettings,
  );
}

Future<List<Garage>> getGarages() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.garagesListSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.listFromJSON,
    response: response,
  );
}

Future<List<Garage>> getOwnedGarages(User owner) async {
  final response = await NetworkService.sendRequest(
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

Future<Garage> postGarage(Garage garage) async {
  final response = await NetworkService.sendRequest(
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

Future<Garage> putGarage(Garage garage) async {
  final response = await NetworkService.sendRequest(
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
