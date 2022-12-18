// Project imports:
import '../models/price_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<List<Price>> getPrices(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.pricesListSlug,
    useAuthToken: true,
    pk: garageId,
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.listFromJSON,
    response: response,
  );
}

Future<Price> postPrice(Price price, int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.pricesListSlug,
    useAuthToken: true,
    pk: garageId,
    body: price.toJSON(),
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.fromJSON,
    response: response,
  );
}

Future<Price> putPrice(Price price) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.pricesDetailSlug,
    useAuthToken: true,
    pk: price.id,
    body: price.toJSON(),
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.fromJSON,
    response: response,
  );
}

Future<void> deletePrice(Price price) async {
  await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.pricesDetailSlug,
    useAuthToken: true,
    pk: price.id,
    body: price.toJSON(),
  );
}
