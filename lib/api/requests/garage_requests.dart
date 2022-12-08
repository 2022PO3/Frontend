import '../models/garage_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<Garage> getGarage(int id) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageSlug + id.toString(),
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );
}

Future<List<Garage>> getGarages() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGaragesSlug,
    useAuthToken: true,
    //    body: body
  );

  return await NetworkHelper.filterResponse(
    callBack: garagesListFromJson,
    response: response,
  );
}
