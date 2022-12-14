import 'package:flutter/cupertino.dart';
import 'package:po_frontend/api/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  Map<int, FrontendNotification> _notifications = {};

  List<FrontendNotification> get getNotifications =>
      _notifications.values.toList();
  FrontendNotification getNotification(int id) => _notifications[id]!;

  void setNotifications(List<FrontendNotification> notifications) {
    _notifications = Map.fromIterable(notifications.map((n) => {n.id: n}));
    notifyListeners();
  }

  void setNotification(FrontendNotification notification) {
    _notifications[notification.id] = notification;
    notifyListeners();
  }
}
