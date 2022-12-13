import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';

import 'package:po_frontend/api/widgets/parking_lot_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';

class SpotSelectionPage extends StatefulWidget {
  const SpotSelectionPage({
    Key? key,
    required this.garageLicenceAndTime,
  }) : super(key: key);

  final GarageLicencePlateAndTime garageLicenceAndTime;
  @override
  State<SpotSelectionPage> createState() => _SpotSelectionPageState();
}

class _SpotSelectionPageState extends State<SpotSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final Garage garage = widget.garageLicenceAndTime.garage;
    final DateTime startDate = widget.garageLicenceAndTime.startDate;
    final DateTime endDate = widget.garageLicenceAndTime.endDate;

    return Scaffold(
      appBar: appBar('Spot selection', true, setState),
      body: FutureBuilder(
        future: getGarageParkingLots(garage.id, {
          'fromDate': startDate.toIso8601String(),
          'toDate': endDate.toIso8601String(),
        }),
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
        (parkingLot.booked ?? false)
            ? showSpotErrorPopUp(context)
            : context.push(
                '/home/reserve/confirm-reservation',
                extra: Reservation(
                  licencePlate: widget.garageLicenceAndTime.licencePlate,
                  userId: getUserId(context),
                  fromDate: startDate,
                  toDate: endDate,
                  parkingLot: parkingLot,
                  garage: garage,
                ),
              );
      },
    );
  }

  void showSpotErrorPopUp(BuildContext context) {
    showFrontendDialog1(
      context,
      'Spot occupied',
      [
        const Text(
          'This spot is occupied and cannot be selected.',
        ),
      ],
    );
  }
}
