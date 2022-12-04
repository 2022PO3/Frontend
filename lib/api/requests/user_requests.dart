import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_provider.dart';
import '../models/user_model.dart';
import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<UserProvider> getUserInfo() async {
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

Future getValidationData(UserProvider userProvider) async {
  final userInfo = await SharedPreferences.getInstance();
  var obtainedEmail = userInfo.getString('email');
  var obtainedToken = userInfo.getString('authToken');

  print(obtainedEmail);
  print(obtainedToken);
}
