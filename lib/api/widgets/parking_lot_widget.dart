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
    return Card(
      shape: Constants.cardBorder,
      color: getColor(),
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: parkingLot.disabled ? Colors.black38 : Colors.black,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Floor: ${parkingLot.floorNumber}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: parkingLot.disabled ? Colors.black38 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if (parkingLot.disabled) {
      return Colors.grey.shade300;
    } else if (!parkingLot.available) {
      return Colors.red.shade300;
    } else {
      return Colors.green.shade400;
    }
  }
}
