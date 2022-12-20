// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/price_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<List<Price>> getPrices(BuildContext context, int garageId) async {
  final response = await NetworkService.sendRequest(
    context,
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

Future<Price> postPrice(BuildContext context, Price price, int garageId) async {
  final response = await NetworkService.sendRequest(
    context,
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

Future<Price> putPrice(BuildContext context, Price price) async {
  final response = await NetworkService.sendRequest(
    context,
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

Future<void> deletePrice(BuildContext context, Price price) async {
  await NetworkService.sendRequest(
    context,
    requestType: RequestType.delete,
    apiSlug: StaticValues.pricesDetailSlug,
    useAuthToken: true,
    pk: price.id,
    body: price.toJSON(),
  );
}
