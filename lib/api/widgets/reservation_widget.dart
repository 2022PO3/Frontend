import 'package:flutter/material.dart';

import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/sized_box.dart';

class ReservationWidget extends StatelessWidget {
  const ReservationWidget({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final bool active = (reservation.fromDate.millisecondsSinceEpoch <=
            DateTime.now().millisecondsSinceEpoch &&
        DateTime.now().millisecondsSinceEpoch <=
            reservation.toDate.millisecondsSinceEpoch);
    final bool done = DateTime.now().isAfter(reservation.toDate);
    final Color color = done ? Colors.black26 : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        color: active
            ? Colors.green.shade100
            : (done ? Colors.grey.shade300 : Colors.white),
        shape: Constants.cardBorder,
        elevation: active ? 10 : (done ? 1 : 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    reservation.garage.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Height(5),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              Row(
                children: [
                  Text(
                    'Licence plate:',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        reservation.licencePlate.formatLicencePlate(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Height(5),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No.',
                      style: TextStyle(
                        fontSize: 20,
                        color: color,
                      ),
                    ),
                    Text(
                      reservation.parkingLot.parkingLotNo.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: color,
                      ),
                    ),
                    const VerticalDivider(),
                    buildReservationTime(reservation, color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildReservationTime(Reservation reservation, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.access_time,
        size: 40,
        color: color,
      ),
      const SizedBox(
        width: 10,
      ),
      buildDateAndTime(
        reservation.fromDate.toIso8601String().substring(11, 16),
        reservation.fromDate.toIso8601String().substring(0, 10),
        color,
      ),
      Icon(
        Icons.arrow_right_alt_outlined,
        size: 40,
        color: color,
      ),
      buildDateAndTime(
        reservation.toDate.toIso8601String().substring(11, 16),
        reservation.toDate.toIso8601String().substring(0, 10),
        color,
      ),
    ],
  );
}

Widget buildDateAndTime(String time, String date, Color color) {
  return Column(
    children: [
      Text(
        time,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      Text(
        date,
        style: TextStyle(
          color: color,
        ),
      ),
    ],
  );
}
