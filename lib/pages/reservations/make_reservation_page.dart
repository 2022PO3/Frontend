import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';

class MakeReservationPage extends StatefulWidget {
  const MakeReservationPage({
    Key? key,
    required this.garageAndLicencePlate,
  }) : super(key: key);

  final GarageAndLicencePlate garageAndLicencePlate;
  @override
  State<MakeReservationPage> createState() => _MakeReservationPageState();
}

class GarageAndLicencePlate {
  const GarageAndLicencePlate({
    required this.garage,
    required this.licencePlate,
  });

  final Garage garage;
  final LicencePlate licencePlate;
}

class _MakeReservationPageState extends State<MakeReservationPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<String> range(int from, int to) {
      return List.generate(to - from + 1, (i) => (i + from).toString());
    }

    List<String> hours = range(1, 23);
    hours.add('0');

    return Scaffold(
      appBar: appBar(title: 'New reservation'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildTitleCard(),
                const Height(5),
                buildFromTimePick(),
                buildToTimePick(),
              ],
            ),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildTitleCard() {
    return buildCard(
      children: [
        const Text(
          'Please pick a time and date:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.indigoAccent,
          ),
        ),
      ],
      expanded: true,
    );
  }

  Widget buildFromTimePick() {
    return buildCard(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'From:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent,
                fontSize: 20,
              ),
            ),
            const Height(10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2022, 11, 1),
                  maxTime: DateTime(2030, 12, 31),
                  onConfirm: (_date) {
                    setState(() {
                      startDate = _date;
                    });
                  },
                  currentTime: startDate,
                  locale: LocaleType.en,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.indigoAccent,
                      ),
                      const Width(2),
                      Text(
                        startDate.toString().substring(0, 10),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.indigoAccent,
                      ),
                      const Width(2),
                      Text(
                        startDate.toString().substring(10, 16),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.edit,
                    size: 18.0,
                    color: Colors.indigoAccent,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildToTimePick() {
    return buildCard(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Until',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent,
                fontSize: 20,
              ),
            ),
            const Height(10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2022, 11, 1),
                  maxTime: DateTime(2030, 12, 31),
                  onConfirm: (_date) {
                    setState(() {
                      endDate = _date;
                    });
                  },
                  currentTime: endDate,
                  locale: LocaleType.en,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.indigoAccent,
                      ),
                      const Width(2),
                      Text(
                        endDate.toString().substring(0, 10),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.indigoAccent,
                      ),
                      const Width(2),
                      Text(
                        endDate.toString().substring(10, 16),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.edit,
                    size: 18.0,
                    color: Colors.indigoAccent,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildButton(
            'Random spot',
            Colors.indigoAccent,
            () => handleRandomSpotSelection(),
            onlyExpanded: true,
          ),
          const Width(10),
          buildButton(
            'Select a spot',
            Colors.indigoAccent,
            () => handleManualSpotSelection(),
            onlyExpanded: true,
          ),
        ],
      ),
    );
  }

  void handleRandomSpotSelection() async {
    if (compareDates(startDate, endDate)) {
      Reservation reservation = await assignReservation(
        widget.garageAndLicencePlate.garage,
        startDate,
        endDate,
      );
      if (mounted) {
        context.push('/home/reserve/confirm-reservation', extra: reservation);
      }
    } else {
      showDateErrorPopUp(context);
    }
  }

  void handleManualSpotSelection() {
    if (compareDates(startDate, endDate)) {
      context.push(
        '/home/reserve/spot-selection',
        extra: GarageLicencePlateAndTime(
          licencePlate: widget.garageAndLicencePlate.licencePlate,
          garage: widget.garageAndLicencePlate.garage,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    } else {
      showDateErrorPopUp(context);
    }
  }

  Future<Reservation> assignReservation(
    Garage garage,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      ParkingLot parkingLot = await assignParkingLot(
        garage.id,
        {
          'fromDate': startDate.toIso8601String(),
          'toDate': endDate.toIso8601String(),
        },
      );

      return Reservation(
        licencePlate: widget.garageAndLicencePlate.licencePlate,
        fromDate: startDate,
        toDate: endDate,
        parkingLot: parkingLot,
        garage: garage,
      );
    } on BackendException catch (e) {
      print(e);
      showFailureDialog(context, e);
    }
    throw Exception();
  }

  bool compareDates(DateTime date, DateTime date2) {
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

void showDateErrorPopUp(BuildContext context) {
  showFrontendDialog1(
    context,
    'Date error',
    [
      const Text(
        'One of the times is before the current time and date, or the second time and date is before the first.',
      ),
    ],
  );
}

class GarageLicencePlateAndTime {
  const GarageLicencePlateAndTime({
    Key? key,
    required this.licencePlate,
    required this.garage,
    required this.startDate,
    required this.endDate,
  });

  final LicencePlate licencePlate;
  final Garage garage;
  final DateTime startDate;
  final DateTime endDate;
}
