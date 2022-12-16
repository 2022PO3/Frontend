import 'package:flutter/cupertino.dart';
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/providers/notification_provider.dart';
import 'package:provider/provider.dart';

List<FrontendNotification> getProviderNotifications(BuildContext context,
    {bool listen = false}) {
  final NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(
    context,
    listen: listen,
  );
  return notificationProvider.getNotifications;
}

void setNotifications(
  BuildContext context,
  List<FrontendNotification> notifications, {
  bool listen = false,
}) {
  final NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(
    context,
    listen: listen,
  );
  return notificationProvider.setNotifications(notifications);
}

void setNotification(
  BuildContext context,
  FrontendNotification notification, {
  bool listen = false,
}) {
  final NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(
    context,
    listen: listen,
  );
  return notificationProvider.setNotification(notification);
}

void deleteProviderNotification(
  BuildContext context,
  FrontendNotification notification, {
  bool listen = false,
}) {
  final NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(
    context,
    listen: listen,
  );
  return notificationProvider.deleteNotification(notification);
}
