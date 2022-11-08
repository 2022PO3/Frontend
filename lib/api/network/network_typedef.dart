import 'package:po_frontend/api/network/network_enums.dart';

typedef NetworkCallBack<R> = R Function(Map<String, dynamic>);
typedef NetworkOnFailureCallBackWithMessage<R> = R Function(
    NetworkResponseErrorType, String);
