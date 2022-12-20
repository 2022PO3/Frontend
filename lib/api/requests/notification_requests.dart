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
    context,
    requestType: RequestType.get,
    apiSlug: StaticValues.notificationsListSlug,
    useAuthToken: true,
  );

  List<FrontendNotification> notifications = await NetworkHelper.filterResponse(
    callBack: FrontendNotification.listFromJSON,
    response: response,
  );
  if (context.mounted) {
    setNotifications(context, notifications);
  }

  return notifications;
}

Future<bool> putNotification(
  BuildContext context,
  FrontendNotification notification,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.put,
    apiSlug: StaticValues.notificationsDetailSlug,
    useAuthToken: true,
    pk: notification.id,
    body: notification.toJSON(),
  );

  return NetworkHelper.validateResponse(response);
}

Future<bool> deleteNotification(
  BuildContext context,
  FrontendNotification notification,
) async {
  final response = await NetworkService.sendRequest(
    context,
    requestType: RequestType.delete,
    apiSlug: StaticValues.notificationsDetailSlug,
    useAuthToken: true,
    pk: notification.id,
  );

  return NetworkHelper.validateResponse(response);
}
