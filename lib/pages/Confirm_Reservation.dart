import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/pages/Spot_Selection.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';

class Confirm_Reservation extends StatefulWidget {
  const Confirm_Reservation({Key? key}) : super(key: key);
  @override
  State<Confirm_Reservation> createState() => _Confirm_ReservationState();
}

class _Confirm_ReservationState extends State<Confirm_Reservation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      spot: parkinglot,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview Reservation'),
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
                  Text("Your selected garage:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Text(garage.name)
                ],
              ),
              Column(children: [
                Text("Your selected time and date:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      _date.toIso8601String().substring(0, 10) +
                          "        " +
                          _date.toIso8601String().substring(11, 16),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                  Text(" Until ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                  Text(
                      _date2.toIso8601String().substring(0, 10) +
                          "        " +
                          _date2.toIso8601String().substring(11, 16),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                ])
              ]),
              Column(
                children: [
                  Text("Your selected spot:",
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
                        ? postData()
                        : showReservationErrorPopUp(context);

                    //CHECKS FOR CORRECT INFO BEFORE TRYING TO POST!!
                  },
                  child: Text(
                    "Confirm reservation",
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
    child: Text("Back"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(
        "The time selected is before the current time or the selected spot is already occupied (perhaps reserved by another user while making this reservation). Try changing the time or spot."),
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

postData() async {
  print("Executing function");
  final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.getReservationSlug,
      useAuthToken: true,
      body: {
        'garageId': reservation.garage,
        'userId': reservation.owner,
        'parkingLotId': reservation.spot,
        'fromDate': reservation.fromDate,
        'toDate': reservation.toDate,
      });

  print("reponse $response");
  print('Response ${response?.body}');
  print('Response status code ${response?.statusCode}');

  return await NetworkHelper.filterResponse(
    callBack: parking_lotsListFromJson,
    response: response,
  );
}
