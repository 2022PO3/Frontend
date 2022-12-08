import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/pages/spot_selection.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ConfirmReservationPage extends StatefulWidget {
  const ConfirmReservationPage({Key? key}) : super(key: key);
  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Garage garage = arguments['selected_garage'];
    final DateTime _date = arguments['selected_startdate'];
    final DateTime _date2 = arguments['selected_enddate'];
    final ParkingLot parkinglot = arguments['selected_spot'];
    final Reservation reservation = Reservation(
        garage: garage,
        fromDate: _date,
        toDate: _date2,
        spot: parkinglot.id,
        owner: userProvider.getUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  const Text('Your selected garage:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Text(garage.name)
                ],
              ),
              Column(children: [
                const Text('Your selected time and date:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      _date.toIso8601String().substring(0, 10) +
                          '        ' +
                          _date.toIso8601String().substring(11, 16),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                  const Text(' Until ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                  Text(
                      _date2.toIso8601String().substring(0, 10) +
                          '        ' +
                          _date2.toIso8601String().substring(11, 16),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                ])
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your selected spot:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  ParkingLotsWidget(parking_lot: parkinglot),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    print(garage.id);
                    print(_date.toString());
                    print(_date2.toString());

                    checkReservation(_date, _date2, parkinglot)
                        ? context.go('/home')
                        : showReservationErrorPopUp(context);
                    postData(reservation);

                    //CHECKS FOR CORRECT INFO BEFORE TRYING TO POST!!
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
      ),
    );
  }

  var now = DateTime.now();
  bool checkReservation(DateTime date, DateTime date2, parkinglot) {
    now = DateTime.now();
    if (now.compareTo(date) > 0) {
      return false;
    }
    if (now.compareTo(date2) > 0) {
      return false;
    }
    if (date.compareTo(date2) > 0) {
      return false;
    }
    if (parkinglot.occupied) {
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

postData(Reservation reservation) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.post,
    apiSlug: StaticValues.getReservationSlug,
    useAuthToken: true,
    body: {
      'garageId': reservation.garage.id,
      'userId': reservation.owner,
      'parkingLotId': reservation.spot,
      'fromDate': reservation.fromDate.toIso8601String(),
      'toDate': reservation.toDate.toIso8601String(),
    },
  );

  return NetworkHelper.validateResponse(response);
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
