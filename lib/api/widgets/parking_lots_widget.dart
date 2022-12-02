import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/parking_lots_model.dart';

class ParkingLotsWidget extends StatelessWidget {
  const ParkingLotsWidget({Key? key, required this.parking_lot})
      : super(key: key);

  final ParkingLots parking_lot;

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
                child: Text("Spot: " + parking_lot.id.toString(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
