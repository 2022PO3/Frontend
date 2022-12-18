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

  Map<String, dynamic> toJSON() {
    throw FrontendException('toJSON-method is not implemented.');
  }

  Future<bool> put() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.put,
      apiSlug: _getDetailSlug(),
      useAuthToken: true,
      pk: id,
      body: toJSON(),
    );

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> delete() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.delete,
      apiSlug: _getDetailSlug(),
      useAuthToken: true,
      pk: id,
    );

    return NetworkHelper.validateResponse(response);
  }

  String _getDetailSlug() {
    String? _detailSlug = detailSlug;
    if (_detailSlug == null) {
      throw FrontendException('The model did not define a detailSlug.');
    }
    return _detailSlug;
  }
}
