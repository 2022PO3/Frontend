// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/notification_model.dart';
import 'package:po_frontend/api/requests/notification_requests.dart';
import 'package:po_frontend/api/widgets/garage_widget.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/loading_page.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/requests/garage_requests.dart';
import '../../api/requests/licence_plate_requests.dart';
import '../../utils/error_widget.dart';
import '../navbar/navbar.dart';
import '../payment_widgets/pay_button.dart';
import '../payment_widgets/timer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Save futures here to use refresh indicator
  bool isLoading = true;
  late Future<List<LicencePlate>> licencePlatesFuture;
  late Future<List<Garage>> garagesFuture;
  late Future<List<FrontendNotification>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    getFutures();
  }

  @override
  void dispose() {
    licencePlatesFuture.ignore();
    garagesFuture.ignore();
    notificationsFuture.ignore();
    super.dispose();
  }

  Future<List<dynamic>> getFutures() async {
    setState(() {
      licencePlatesFuture = getLicencePlates();
      garagesFuture = getGarages();
      notificationsFuture = getNotifications(context);
    });

    saveUserToProvider(context);
    List<dynamic> futureList = await Future.wait([
      licencePlatesFuture,
      garagesFuture,
      notificationsFuture,
    ]);

    setState(() {
      isLoading = false;
    });

    return futureList;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingPage()
        : LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              drawer: constraints.maxWidth > 600
                  ? null
                  : Navbar(garagesFuture: garagesFuture),
              appBar: AppBar(
                automaticallyImplyLeading: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [(Colors.indigo), (Colors.indigoAccent)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                title: Text(
                  getUserFirstName(context),
                ),
                actions: [generateNotificationsButton()],
              ),
              body: Row(
                children: [
                  if (constraints.maxWidth > 600)
                    Navbar(
                      garagesFuture: garagesFuture,
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: getFutures,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics().applyTo(
                          const BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: SimpleHeaderDelegate(
                              child: CurrentParkingSessionsListWidget(
                                licencePlatesFuture: licencePlatesFuture,
                              ),
                              maxHeight: min(
                                MediaQuery.of(context).size.shortestSide / 2.5,
                                220,
                              ),
                              minHeight: min(
                                MediaQuery.of(context).size.shortestSide / 5,
                                100,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: GarageListWidget(
                              garagesFuture: garagesFuture,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
  }

  Widget generateNotificationsButton() {
    const Icon notificationIcon = Icon(
      Icons.notifications_rounded,
      color: Colors.white,
    );
    return FutureBuilder(
      future: notificationsFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<FrontendNotification> notifications =
              snapshot.data as List<FrontendNotification>;
          int newNotifications = (notifications.where((n) => !n.seen)).length;
          return TextButton(
            onPressed: () {
              context.go('/home/notifications');
            },
            child: newNotifications != 0
                ? badges.Badge(
                    badgeColor: Colors.redAccent,
                    badgeContent: Text(
                      newNotifications.toString(),
                    ),
                    child: notificationIcon,
                  )
                : notificationIcon,
          );
        } else {
          return TextButton(
            onPressed: () {
              context.go('/home/notifications');
            },
            child: notificationIcon,
          );
        }
      }),
    );
  }
}

class SimpleHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Delegate for a SliverPersistentHeader with a provided minimum and maximum
  /// height.
  SimpleHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: shrinkOffset > (maxExtent - minExtent) ? 5 : 0,
      child: child,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CurrentParkingSessionsListWidget extends StatelessWidget {
  /// Horizontal scrollview with a CurrentParkingSessionWidget for every garage
  /// the user is parked at.
  CurrentParkingSessionsListWidget({
    Key? key,
    required this.licencePlatesFuture,
  }) : super(key: key);

  final Future<List<LicencePlate>> licencePlatesFuture;
  final ScrollController mainController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LicencePlate>>(
      future: licencePlatesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<LicencePlate> licencePlates =
              snapshot.data as List<LicencePlate>;

          licencePlates = licencePlates
              .where((element) => element.garageId != null)
              .toList();

          if (licencePlates.isEmpty) {
            return const SizedBox.square(
              dimension: 0,
            );
          } else {
            return Scrollbar(
              controller: mainController,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: mainController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CurrentParkingSessionWidget(
                    licencePlate: licencePlates[index],
                  );
                },
                itemCount: licencePlates.length,
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SnapshotErrorWidget(
            snapshot: snapshot,
          );
        }
        return const SizedBox.square(
          dimension: 0,
        );
      },
    );
  }
}

class CurrentParkingSessionWidget extends StatefulWidget {
  /// Widget for showing information about a specific garage the user is parked
  /// at, how long the user has parked there and providing a pay button.
  const CurrentParkingSessionWidget({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final LicencePlate licencePlate;

  @override
  State<CurrentParkingSessionWidget> createState() =>
      _CurrentParkingSessionWidgetState();
}

class _CurrentParkingSessionWidgetState
    extends State<CurrentParkingSessionWidget> {
  late Future<Garage> garageFuture;

  @override
  void initState() {
    garageFuture = getGarage(widget.licencePlate.garageId!);
    super.initState();
  }

  @override
  void dispose() {
    garageFuture.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.longestSide;
    return FutureBuilder<Garage>(
      future: garageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Garage garage = snapshot.data as Garage;

          return _buildData(context, garage, height);
        } else if (snapshot.hasError) {
          return SnapshotErrorWidget(
            snapshot: snapshot,
          );
        }
        return _buildLoading(context);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      shape: Constants.cardBorder,
      child: SizedBox(
        width: MediaQuery.of(context).size.shortestSide - 8,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildData(BuildContext context, Garage garage, double height) {
    double switchHeight = height / 6;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(4),
      shape: Constants.cardBorder,
      child: SizedBox(
        width: MediaQuery.of(context).size.shortestSide - 8,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'title_${widget.licencePlate.licencePlate}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Parked with ${widget.licencePlate.formatLicencePlate()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (constraints.maxHeight < switchHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        child: PayPreviewButton(
                          licencePlate: widget.licencePlate,
                          garage: garage,
                        ),
                      ),
                  ],
                ),
                if (constraints.maxHeight > switchHeight) const Spacer(),
                if (constraints.maxHeight > switchHeight)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Duration:'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                            tag: 'timer_${widget.licencePlate.licencePlate}',
                            child: TimerWidget(
                              start: widget.licencePlate.updatedAt,
                              textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide /
                                        20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (constraints.maxHeight > switchHeight)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2,
                      ),
                      child: PayPreviewButton(
                        licencePlate: widget.licencePlate,
                        garage: garage,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum SortByEnum { none, province, freeSpots }

enum SortDirection { none, up, down }

class GarageListWidget extends StatefulWidget {
  const GarageListWidget({super.key, required this.garagesFuture});

  final Future<List<Garage>> garagesFuture;

  @override
  State<GarageListWidget> createState() => _GarageListWidgetState();
}

class _GarageListWidgetState extends State<GarageListWidget> {
  SortDirection sortDirection = SortDirection.none;
  SortByEnum sortBy = SortByEnum.none;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.longestSide;

    return FutureBuilder(
      future: widget.garagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Garage> garages = snapshot.data as List<Garage>;
          garages = sortGarages(garages);

          final List<Widget> garageWidgets =
              garages.map((e) => GarageWidget(garage: e)).toList();
          return Column(
            children: [
              buildSortRow(height),
              ...garageWidgets,
            ],
          );
        } else if (snapshot.hasError) {
          return SnapshotErrorWidget(
            snapshot: snapshot,
          );
        }
        return const Center(
          child: SizedBox.square(
            dimension: 25,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildSortRow(double height) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (sortBy != SortByEnum.none) buildSortDirectionButton(),
                buildSortText(),
                buildSortButton(),
              ],
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }

  Widget buildSortDirectionButton() {
    final Icon directionIcon = sortDirection == SortDirection.up
        ? const Icon(
            Icons.arrow_upward_rounded,
            size: 20,
          )
        : const Icon(
            Icons.arrow_downward_rounded,
            size: 20,
          );
    return TextButton(
      onPressed: () {
        if (sortDirection == SortDirection.up) {
          setState(() {
            sortDirection = SortDirection.down;
          });
        } else if (sortDirection == SortDirection.down) {
          setState(() {
            sortDirection = SortDirection.up;
          });
        }
        setState(() {});
      },
      child: directionIcon,
    );
  }

  Widget buildSortText() {
    late String sortText;
    switch (sortBy) {
      case SortByEnum.none:
        sortText = 'No sorting';
        break;
      case SortByEnum.province:
        sortText = 'Sorted by province';
        break;
      case SortByEnum.freeSpots:
        sortText = 'Sorted by free spots';
        break;
    }
    return Text(
      sortText,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }

  Widget buildSortButton() {
    return TextButton(
      onPressed: alterSortByPopUp,
      child: const Icon(
        Icons.sort,
        size: 20,
      ),
    );
  }

  void alterSortByPopUp() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: Constants.cardBorder,
          title: const Text('Sort by'),
          contentPadding: const EdgeInsets.only(
            top: 10,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildRadioButton('None', SortByEnum.none),
              buildRadioButton('Province', SortByEnum.province),
              buildRadioButton('Free spots', SortByEnum.freeSpots),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(
                              Constants.borderRadius,
                            ),
                            bottomLeft: Radius.circular(
                              Constants.borderRadius,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  RadioListTile buildRadioButton(
    String text,
    SortByEnum value,
  ) {
    return RadioListTile(
        title: Text(text),
        value: value,
        groupValue: sortBy,
        onChanged: (value) {
          setState(() {
            sortBy = value;
            sortDirection = SortDirection.up;
          });
          context.pop();
        });
  }

  List<Garage> sortGarages(List<Garage> garages) {
    final bool up = sortDirection == SortDirection.up;
    // Filter out garages with no parking lots
    garages = garages.where((element) => element.parkingLots > 0).toList();
    switch (sortBy) {
      case SortByEnum.none:
        break;
      case SortByEnum.province:
        up
            ? garages.sort((g1, g2) => g1.garageSettings.location.province
                .toString()
                .compareTo(g2.garageSettings.location.province.toString()))
            : garages.sort((g2, g1) => g1.garageSettings.location.province
                .toString()
                .compareTo(g2.garageSettings.location.province.toString()));
        break;
      case SortByEnum.freeSpots:
        up
            ? garages.sort((g1, g2) => (g1.unoccupiedLots / g1.parkingLots)
                .compareTo((g2.unoccupiedLots / g2.parkingLots)))
            : garages.sort((g2, g1) => (g1.unoccupiedLots / g1.parkingLots)
                .compareTo((g2.unoccupiedLots / g2.parkingLots)));
        break;
    }
    return garages;
  }
}

void saveUserToProvider(BuildContext context) async {
  if (getUserId(context) == 0) {
    updateUserInfo(context);
  }
}
