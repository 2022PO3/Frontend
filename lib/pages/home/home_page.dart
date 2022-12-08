import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/enums.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      saveUserToProvider(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ),
        title: const Center(
          child: Text('Garages'),
        ),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          print(ModalRoute.of(context)?.settings.name);
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<Garage> garages = snapshot.data as List<Garage>;

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

class CurrentParkingSessionWidget extends StatelessWidget {
  /// Widget for showing information about a specific garage the user is parked
  /// at, how long the user has parked there and providing a pay button.

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
}

class GarageListWidget extends StatelessWidget {
  const GarageListWidget({Key? key, required this.garagesFuture})
      : super(key: key);
Future<User> getUserInfo() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getUserSlug,
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
    callBack: User.userFromJson,
    response: response,
  );
}

Future<List<Garage>> getData() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGaragesSlug,
    useAuthToken: true,
  );

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

void saveUserToProvider(BuildContext context) async {
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(await getUserInfo());
}
