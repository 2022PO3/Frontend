import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/api/widgets/parking_lot_widget.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';
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
      appBar: appBar('Reservation overview', false, null),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Your selected garage:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              reservation.garage.name,
            ),
            const Text(
              'Numberplate for this reservation:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              reservation.licencePlate.formatLicencePlate(),
            ),
            const Text(
              'Your selected time and date:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            buildReservationTime(reservation),
            const Text(
              'Your selected spot:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            ParkingLotsWidget(parkingLot: reservation.parkingLot),
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () async {
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
                      showFailureDialog(context, e);
                    }
                  } else {
                    showReservationErrorPopUp(context);
                  }
                },
                child: const Text(
                  'Confirm reservation',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReservationConfirmationCard(String text) {
    return Card(shape: Constants.cardBorder);
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
  // set up the buttons
  Widget backButton = TextButton(
    child: const Text('Back'),
    onPressed: () {
      context.pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text(
        'The time selected is before the current time or the selected spot is already occupied (perhaps reserved by another user while making this reservation). Try changing the time or spot.'),
    actions: [
      backButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showPostErrorPopUp(BuildContext context) {
  // set up the buttons
  Widget backButton = TextButton(
    child: const Text('Back'),
    onPressed: () {
      context.pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text("Reservation wasn't booked, try again."),
    actions: [
      backButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
