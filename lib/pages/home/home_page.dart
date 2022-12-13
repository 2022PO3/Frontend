import 'package:flutter/material.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/requests/garage_requests.dart';
import '../../api/requests/licence_plate_requests.dart';
import '../../utils/error_widget.dart';
import '../navbar/navbar.dart';
import '../payment_widgets/pay_button.dart';
import '../payment_widgets/timer_widget.dart';

import 'dart:async';

import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/widgets/garage_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Save futures here to use refresh indicator
  late Future<List<LicencePlate>> licencePlatesFuture;
  late Future<List<Garage>> garagesFuture;

  @override
  void initState() {
    super.initState();

    getFutures();
  }

  Future getFutures() async {
    setState(() {
      licencePlatesFuture = getLicencePlates();
      garagesFuture = getAllGarages();
    });
    saveUserToProvider(context);

    return Future.wait([licencePlatesFuture, garagesFuture]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Navbar(),
      appBar: appBar(getUserFirstName(context), false, null),
      body: RefreshIndicator(
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
                maxHeight: MediaQuery.of(context).size.shortestSide / 2.5,
                minHeight: MediaQuery.of(context).size.shortestSide / 5,
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
  const CurrentParkingSessionsListWidget({
    Key? key,
    required this.licencePlatesFuture,
  }) : super(key: key);

  final Future<List<LicencePlate>> licencePlatesFuture;

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
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CurrentParkingSessionWidget(
                  licencePlate: licencePlates[index],
                );
              },
              itemCount: licencePlates.length,
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

class CurrentParkingSessionWidget extends StatelessWidget {
  /// Widget for showing information about a specific garage the user is parked
  /// at, how long the user has parked there and providing a pay button.
  const CurrentParkingSessionWidget({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final LicencePlate licencePlate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Garage>(
      future: getGarage(licencePlate.garageId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Garage garage = snapshot.data as Garage;

          return _buildData(context, garage);
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
      child: SizedBox(
        width: MediaQuery.of(context).size.shortestSide,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildData(BuildContext context, Garage garage) {
    return SizedBox(
      width: MediaQuery.of(context).size.shortestSide,
      child: Card(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'title_${licencePlate.licencePlate}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Parked at ${garage.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            garage.garageSettings.location.toString(),
                          )
                        ],
                      ),
                    ),
                    if (constraints.maxHeight < 110)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PayPreviewButton(
                          licencePlate: licencePlate,
                          garage: garage,
                        ),
                      ),
                  ],
                ),
                Spacer(
                  flex: constraints.maxHeight > 131 ? 3 : 1,
                ),
                if (constraints.maxHeight > 125)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Licence plate:'),
                        SizedBox(
                          width: MediaQuery.of(context).size.shortestSide / 5,
                        ),
                        Text(
                          licencePlate.formatLicencePlate(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (constraints.maxHeight > 110)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Hero(
                          tag: 'timer_${licencePlate.licencePlate}',
                          child: TimerWidget(
                            start: licencePlate.updatedAt,
                            textStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.shortestSide / 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2,
                          ),
                          child: PayPreviewButton(
                            licencePlate: licencePlate,
                            garage: garage,
                          ),
                        ),
                      ],
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

class GarageListWidget extends StatelessWidget {
  const GarageListWidget({
    Key? key,
    required this.garagesFuture,
  }) : super(key: key);

  final Future<List<Garage>> garagesFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: garagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final List<Garage> garages = snapshot.data as List<Garage>;

          return Column(
            children: garages
                .map(
                  (e) => GarageWidget(
                    garage: e,
                  ),
                )
                .toList(),
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
}

void saveUserToProvider(BuildContext context) async {
  if (getUserId(context) == 0) {
    updateUserInfo(context);
  }
}
