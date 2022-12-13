import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/utils/constants.dart';

class ReservationWidget extends StatelessWidget {
  const ReservationWidget({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: Constants.cardBorder,
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              Row(
                children: [
                  const Text('Licence plate:'),
                  Expanded(
                    child: Center(
                      child: Text(
                        reservation.licencePlate.formatLicencePlate(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      reservation.parkingLot.parkingLotNo.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const VerticalDivider(),
                    buildReservationTime(reservation),
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

Widget buildReservationTime(Reservation reservation) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.access_time,
        size: 40,
      ),
      const SizedBox(
        width: 10,
      ),
      buildDateAndTime(
        reservation.fromDate.toIso8601String().substring(11, 16),
        reservation.fromDate.toIso8601String().substring(0, 10),
      ),
      const Icon(
        Icons.arrow_right_alt_outlined,
        size: 40,
      ),
      buildDateAndTime(
        reservation.toDate.toIso8601String().substring(11, 16),
        reservation.toDate.toIso8601String().substring(0, 10),
      ),
    ],
  );
}

Widget buildDateAndTime(String time, String date) {
  return Column(
    children: [
      Text(
        time,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        date,
      ),
    ],
  );
}
