// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/api/widgets/notification_widget.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);

    /*_tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        /*setState(() {
          _selectedTab = _tabController.index;
        });*/
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Notifications',
        refreshButton: true,
        refreshFunction: () => setState(() => {}),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: TabBar(
                unselectedLabelColor: Colors.blue,
                labelColor: Colors.blue,
                indicatorColor: Colors.white,
                controller: _tabController,
                labelPadding: const EdgeInsets.all(0.0),
                tabs: [
                  _getTab('All'),
                  _getTab('Unseen'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  buildNotifications(
                    notificationList: getProviderNotifications(context),
                  ),
                  buildNotifications(
                    notificationList: getProviderNotifications(context),
                    unSeen: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTab(String text) {
    return Tab(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildNotifications({
    required List<FrontendNotification> notificationList,
    bool unSeen = false,
  }) {
    if (unSeen) {
      notificationList = notificationList.where((n) => !n.seen).toList();
    }
    return notificationList.isEmpty
        ? buildNoNotificationsCard()
        : ListView.builder(
            itemBuilder: (context, index) {
              return NotificationWidget(
                notification: notificationList[index],
              );
            },
            itemCount: notificationList.length,
            scrollDirection: Axis.vertical,
          );
  }

  Widget buildNoNotificationsCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                shape: Constants.cardBorder,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    'There are currently no notifications for you!',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
