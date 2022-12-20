// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/api/requests/notification_requests.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/notifications.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
  });

  final FrontendNotification notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: Constants.cardBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(widget.notification.title),
              buildContent(widget.notification.content),
              const SizedBox(
                height: 5,
              ),
              buildCreatedAt(widget.notification.createdAt),
            ],
          ),
        ),
      ),
      onTap: () => openNotificationDialog(widget.notification),
      onLongPress: () => openingNotificationDeleteDialog(widget.notification),
    );
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.indigoAccent,
      ),
    );
  }

  Widget buildContent(String content) {
    return Text(
      content,
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget buildCreatedAt(DateTime createdAt) {
    final DateFormat format = DateFormat('d MMM, HH:mm');
    final String dateString = format.format(createdAt);
    return Text(
      dateString,
      style: const TextStyle(
        color: Colors.black45,
      ),
    );
  }

  void openNotificationDialog(FrontendNotification notification) {
    return showFrontendDialog1(
      context,
      notification.title,
      [Text(notification.content)],
      buttonFunction: () => handleSetNotificationSeen(notification),
    );
  }

  void handleSetNotificationSeen(FrontendNotification notification) {
    context.pop();
    if (!notification.seen) {
      notification.seen = true;
      setNotification(context, notification);
      putNotification(context, notification);
    }
  }

  void openingNotificationDeleteDialog(FrontendNotification notification) {
    return showFrontendDialog2(
        context,
        'Delete notification',
        [const Text('Are you sure that you want to delete this notification?')],
        () => handleDeleteNotification(notification),
        leftButtonText: 'Yes',
        rightButtonText: 'No');
  }

  void handleDeleteNotification(FrontendNotification notification) async {
    deleteProviderNotification(context, notification);
    deleteNotification(context, notification);
    context.pop();
    setState(() {});
  }
}
