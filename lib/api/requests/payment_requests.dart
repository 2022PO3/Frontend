import 'package:url_launcher/url_launcher.dart';

import '../network/network_helper.dart';
import '../network/network_service.dart';
import '../network/static_values.dart';

Future<void> startPaymentSession({required String licencePlate}) async {
  final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.createPaymentSessionSlug,
      useAuthToken: true,
      body: {'licence_plate': licencePlate});
  await NetworkHelper.filterResponse(
    callBack: (Map<String, dynamic> json) async {
      Uri url = Uri.parse(json['url']);

      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    },
    response: response,
  );
}
