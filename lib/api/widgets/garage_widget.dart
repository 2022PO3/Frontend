import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/pages/New_Reservation.dart';
import 'package:po_frontend/pages/Spot_Selection.dart';

class GarageWidget extends StatelessWidget {
  const GarageWidget({Key? key, required this.garage}) : super(key: key);

  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Text(
                garage.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(garage.isFull ? 'Full' : 'Empty places'),
            ),
            SizedBox(
              width: 300,
              child: Text('${garage.unoccupiedLots}/${garage.parkingLots}'),
            ),
          ],
        ),
        onTap: () {
          context.push('/home/garage-info/${garage.id}');
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, '/New_Reservation',
            arguments: {'garage': garage});
      },
    );
  }
}
