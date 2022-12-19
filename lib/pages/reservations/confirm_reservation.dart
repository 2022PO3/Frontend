// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/reservation_requests.dart';
import 'package:po_frontend/api/widgets/parking_lot_widget.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/dialogs.dart';

class ConfirmReservationPage extends StatefulWidget {
  const ConfirmReservationPage({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  final Reservation reservation;

  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  @override
  Widget build(BuildContext context) {
    final Reservation reservation = widget.reservation;

    return Scaffold(
      appBar: appBar(title: 'Reservation overview'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildCard(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your selected garage:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    Center(
                      child: Text(
                        reservation.garage.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  expanded: true,
                ),
                buildCard(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Numberplate for this reservation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    Center(
                      child: Text(
                        reservation.licencePlate.formatLicencePlate(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  expanded: true,
                ),
                buildCard(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your selected time and date:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    Center(
                      child: buildReservationTime(
                        reservation,
                        Colors.black,
                      ),
                    ),
                  ],
                ),
                buildCard(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your selected spot:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    Center(
                      child: ParkingLotsWidget(
                        parkingLot: reservation.parkingLot,
                      ),
                    ),
                  ],
                  expanded: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: buildButton(
                'Confirm reservation',
                Colors.indigoAccent,
                () => handleConfirmReservation(reservation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleConfirmReservation(Reservation reservation) async {
    if (checkReservation(
      reservation.fromDate,
      reservation.toDate,
    )) {
      try {
        await postReservation(reservation);
        if (mounted) {
          showSuccessDialog(
            context,
            'Successfully created reservation',
            'Your reservation has been created successfully. You will no be redirected to the home screen',
          );
        }
        await Future.delayed(
          const Duration(seconds: 2),
        );
        if (mounted) context.go('/home');
      } on BackendException catch (e) {
        print(e);
        print(e.toString().contains('already'));
        if (e.toString().contains('already')) {
          showFrontendDialog1(
            context,
            'Already booked',
            [
              const Text(
                  'The licence plate you have selected already has a reservation that day and time. Please go back and specify a different time.')
            ],
          );
        } else {
          showFailureDialog(context, e);
        }
      }
    } else {
      showReservationErrorPopUp(context);
    }
  }

  bool checkReservation(DateTime date, DateTime date2) {
    DateTime now = DateTime.now();
    if (now.compareTo(date) > 0) {
      return false;
    }
    if (now.compareTo(date2) > 0) {
      return false;
    }
    if (date.compareTo(date2) > 0) {
      return false;
    }
    return true;
  }
}

void showReservationErrorPopUp(BuildContext context) {
  return showFrontendDialog1(
    context,
    'Date error',
    [
      const Text(
          'The time selected is before the current time or the selected spot is already occupied (perhaps reserved by another user while making this reservation). Try changing the time or spot.'),
    ],
  );
}
