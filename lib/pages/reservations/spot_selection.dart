import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';

import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SpotSelectionPage extends StatefulWidget {
  const SpotSelectionPage({
    Key? key,
    required this.garageAndTime,
  }) : super(key: key);

  final GarageAndTime garageAndTime;
  @override
  State<SpotSelectionPage> createState() => _SpotSelectionPageState();
}

class _SpotSelectionPageState extends State<SpotSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final Garage garage = widget.garageAndTime.garage;
    final DateTime startDate = widget.garageAndTime.startDate;
    final DateTime endDate = widget.garageAndTime.endDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Selection'),
      ),
      body: FutureBuilder(
        future: getGarageParkingLots(garage.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<ParkingLot> parkingLots =
                snapshot.data as List<ParkingLot>;

            return GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: parkingLots
                  .map(
                    (parkingLot) => buildClickableParkingLotWidget(
                      parkingLot,
                      garage,
                      startDate,
                      endDate,
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.error.toString(),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildClickableParkingLotWidget(
    ParkingLot parkingLot,
    Garage garage,
    DateTime startDate,
    DateTime endDate,
  ) {
    return InkWell(
      child: ParkingLotsWidget(parkingLot: parkingLot),
      onTap: () {
        final UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);

        parkingLot.occupied
            ? showSpotErrorPopUp(context)
            : context.push(
                '/home/reserve/confirm-reservation',
                extra: Reservation(
                  userId: userProvider.getUser.id,
                  fromDate: startDate,
                  toDate: endDate,
                  parkingLot: parkingLot,
                  garage: garage,
                ),
              );
      },
    );
  }
}

void showSpotErrorPopUp(BuildContext context) {
  Widget backButton = TextButton(
    child: const Text('Back'),
    onPressed: () {
      context.pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text('This spot is occupied.'),
    actions: [
      backButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
