// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:po_frontend/api/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  Map<int, FrontendNotification> _notifications = {};

  List<FrontendNotification> get getNotifications =>
      _notifications.values.toList();
  FrontendNotification getNotification(int id) => _notifications[id]!;

  void setNotifications(List<FrontendNotification> notifications) {
    Map<int, FrontendNotification> notificationsMap = {};
    for (FrontendNotification notification in notifications) {
      notificationsMap.addAll({notification.id: notification});
    }
    _notifications = notificationsMap;
    notifyListeners();
  }

  void setNotification(FrontendNotification notification) {
    _notifications[notification.id] = notification;
    notifyListeners();
  }

  void deleteNotification(FrontendNotification notification) {
    _notifications.remove(notification.id);
    notifyListeners();
  }
}
