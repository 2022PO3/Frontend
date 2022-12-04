import '../models/licence_plate_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<List<LicencePlate>> getLicencePlates() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getLicencePlatesSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: LicencePlate.listFromJSON,
    response: response,
  );
}
