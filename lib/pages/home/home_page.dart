import 'package:flutter/material.dart';
import 'package:po_frontend/providers/user_provider.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/requests/garage_requests.dart';
import '../../api/requests/licence_plate_requests.dart';
import '../error_widget.dart';
import '../payment_widgets/pay_button.dart';
import '../payment_widgets/timer_widget.dart';
import 'navbar.dart';

import 'dart:async';
import 'package:provider/provider.dart';

import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/widgets/garage_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      garagesFuture = getGarages();
    });

    return Future.wait([licencePlatesFuture, garagesFuture]);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        endDrawer: const Navbar(),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [(Colors.indigo), (Colors.indigoAccent)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
            ),
            title: Center(
                child: Text(userProvider.getUser.firstName ??
                    '')) //UserinfoPr._email)),
            ),
        body: RefreshIndicator(
          onRefresh: getFutures,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: SimpleHeaderDelegate(
                  child: CurrentParkingSessionsListWidget(
                    licencePlatesFuture: licencePlatesFuture,
                  ),
                  maxHeight: MediaQuery.of(context).size.shortestSide / 2,
                  minHeight: MediaQuery.of(context).size.shortestSide / 4,
                ),
              ),
              SliverToBoxAdapter(
                child: GarageListWidget(
                  garagesFuture: garagesFuture,
                ),
              ),
            ],
          ),
        ));
  }
}

class CurrentParkingSessionsListWidget extends StatelessWidget {
  const CurrentParkingSessionsListWidget(
      {Key? key, required this.licencePlatesFuture})
      : super(key: key);

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
                    licencePlate: licencePlates[index]);
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

class SimpleHeaderDelegate extends SliverPersistentHeaderDelegate {
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

class CurrentParkingSessionWidget extends StatelessWidget {
  const CurrentParkingSessionWidget({Key? key, required this.licencePlate})
      : super(key: key);

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
        width: MediaQuery.of(context).size.shortestSide / 2,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildData(BuildContext context, Garage garage) {
    return Card(
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parked at ${garage.name}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Text(garage.garageSettings.location.toString())
                    ],
                  ),
                ),
                if (constraints.maxHeight < 110)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PayButton(
                      licencePlate: licencePlate,
                      garage: garage,
                      isPreview: true,
                    ),
                  )
              ],
            ),
            Spacer(
              flex: constraints.maxHeight > 131 ? 3 : 1,
            ),
            if (constraints.maxHeight > 160)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(licencePlate.licencePlate)),
            if (constraints.maxHeight > 110)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TimerWidget(
                      start: licencePlate.updatedAt,
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.shortestSide / 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2),
                      child: PayButton(
                        licencePlate: licencePlate,
                        garage: garage,
                        isPreview: true,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}

class GarageListWidget extends StatelessWidget {
  const GarageListWidget({Key? key, required this.garagesFuture})
      : super(key: key);

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
            mainAxisSize: MainAxisSize.min,
            children: garages.map((e) => GarageWidget(garage: e)).toList(),
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
