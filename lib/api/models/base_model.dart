// Project imports:
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';

abstract class BaseModel {
  final String? detailSlug;
  final int id;

  const BaseModel({
    this.detailSlug,
    required this.id,
  });

  Future<bool> delete() async {
    print(detailSlug);
    String? _detailSlug = detailSlug;
    if (_detailSlug == null) {
      throw FrontendException('The model did not define a detailSlug.');
    }

    final response = await NetworkService.sendRequest(
      requestType: RequestType.delete,
      apiSlug: _detailSlug,
      useAuthToken: true,
      pk: id,
    );

    return NetworkHelper.validateResponse(response);
  }
}
