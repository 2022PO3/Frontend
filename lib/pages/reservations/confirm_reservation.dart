import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/pages/reservations/spot_selection.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:provider/provider.dart';

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
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    final Reservation reservation = widget.reservation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
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
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Your selected time and date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                buildReservationTime(reservation),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your selected spot:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ParkingLotsWidget(parkingLot: reservation.parkingLot),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () async {
                  if (checkReservation(reservation.fromDate, reservation.toDate,
                      reservation.parkingLot)) {
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

  bool checkReservation(DateTime date, DateTime date2, ParkingLot parkingLot) {
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
    if (parkingLot.occupied) {
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
