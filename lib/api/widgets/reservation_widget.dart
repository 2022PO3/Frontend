// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/sized_box.dart';

Widget buildReservationWidget(Reservation reservation) {
  print(reservation.toDate);
  print(DateTime.now().toUtc());
  final bool active = (reservation.fromDate.isBefore(DateTime.now()) &&
      DateTime.now().isBefore(reservation.toDate));
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

Widget buildReservationTime(Reservation reservation, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.access_time,
        size: 40,
        color: color,
      ),
      const Width(10),
      _buildDateAndTime(
        reservation.fromDate,
        color,
      ),
      Icon(
        Icons.arrow_right_alt_outlined,
        size: 40,
        color: color,
      ),
      _buildDateAndTime(
        reservation.toDate,
        color,
      ),
    ],
  );
}

Widget _buildDateAndTime(DateTime dateTime, Color color) {
  String time = dateTime
      .add(const Duration(hours: 1))
      .toIso8601String()
      .substring(11, 16);
  String date =
      dateTime.add(const Duration(hours: 1)).toIso8601String().substring(0, 10);
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
