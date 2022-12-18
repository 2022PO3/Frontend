// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/utils/constants.dart';

class ParkingLotsWidget extends StatelessWidget {
  const ParkingLotsWidget({
    Key? key,
    required this.parkingLot,
  }) : super(key: key);

  final ParkingLot parkingLot;

  @override
  Widget build(BuildContext context) {
    bool booked = parkingLot.booked ?? false;
    return Card(
      shape: Constants.cardBorder,
      color: booked ? Colors.red.shade300 : Colors.lightGreen.shade400,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Spot: ${parkingLot.parkingLotNo}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Floor: ${parkingLot.floorNumber}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
