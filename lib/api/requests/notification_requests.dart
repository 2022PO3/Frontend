// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/utils/notifications.dart';

Future<List<FrontendNotification>> getNotifications(
  BuildContext context,
) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getNotificationsSlug,
    useAuthToken: true,
  );

  List<FrontendNotification> notifications = await NetworkHelper.filterResponse(
    callBack: FrontendNotification.listFromJSON,
    response: response,
  );
  setNotifications(context, notifications);

  return notifications;
}

Future<bool> putNotification(FrontendNotification notification) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.put,
    apiSlug: StaticValues.pkNotificationsSlug,
    useAuthToken: true,
    pk: notification.id,
    body: notification.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> deleteNotification(
  FrontendNotification notification,
) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.delete,
    apiSlug: StaticValues.pkNotificationsSlug,
    useAuthToken: true,
    pk: notification.id,
  );

  return NetworkHelper.validateResponse(response);
}
