import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<User> getUserInfo() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getUserSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: User.userFromJson,
    response: response,
  );
}
