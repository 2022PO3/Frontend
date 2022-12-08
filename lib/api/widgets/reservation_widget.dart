import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/models/garage_model.dart';

class ReservationWidget extends StatelessWidget {
  const ReservationWidget({Key? key, required this.reservation})
      : super(key: key);

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: Text(reservation.garage.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 300,
            child: Text("From: " +
                reservation.fromDate.toIso8601String().substring(0, 10) +
                "        " +
                reservation.fromDate.toIso8601String().substring(11, 16)),
          ),
          SizedBox(
            width: 300,
            child: Text("        "),
          ),
          SizedBox(
            width: 300,
            child: Text("Until: " +
                reservation.toDate.toIso8601String().substring(0, 10) +
                "        " +
                reservation.toDate.toIso8601String().substring(11, 16)),
          ),
        ],
      ),
    );
  }
}
