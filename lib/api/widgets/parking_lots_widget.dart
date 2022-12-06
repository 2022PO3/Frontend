import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/parking_lots_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';

class ParkingLotsWidget extends StatelessWidget {
  const ParkingLotsWidget({Key? key, required this.parking_lot})
      : super(key: key);

  final ParkingLot parking_lot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Text("Floor: " + parking_lot.floorNumber.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                child: Text("  Spot: " + parking_lot.id.toString(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            SizedBox(
                child: parking_lot.occupied
                    ? (Text("  Occupied",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)))
                    : Text("  Available",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green))),
          ],
        ),
      ),
    );
  }
}
