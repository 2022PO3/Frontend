import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

Future<List<OpeningHour>> getOpeningHours(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.openingHoursListSlug,
    useAuthToken: true,
    pk: garageId,
  );
  return await NetworkHelper.filterResponse(
      callBack: OpeningHour.listFromJSON, response: response);
}
