import '../models/price_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<List<Price>> getPrices(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGaragePricesSlug,
    useAuthToken: true,
    pk: garageId,
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.listFromJSON,
    response: response,
  );
}

Future<Price> createPrice(Price price) async {
  var data = Price.toJSON(price);
  data.remove('id');

  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: '${StaticValues.getGaragePricesSlug}/${price.garageId}',
    useAuthToken: true,
    body: data,
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.fromJSON,
    response: response,
  );
}

Future<Price> updatePrice(Price price) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.pricesSlug,
    useAuthToken: true,
    pk: price.id,
    body: Price.toJSON(price),
  );

  return await NetworkHelper.filterResponse(
    callBack: Price.fromJSON,
    response: response,
  );
}

Future<void> deletePrice(Price price) async {
  await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: '${StaticValues.pricesSlug}/${price.id}',
    useAuthToken: true,
    pk: price.id,
    body: Price.toJSON(price),
  );
}
