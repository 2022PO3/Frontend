import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';

class GarageWidget extends StatelessWidget {
  const GarageWidget({
    Key? key,
    required this.garage,
  }) : super(key: key);

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
              child: Text(
                garage.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              child: Text(garage.isFull ? 'Full' : 'Empty places'),
            ),
            SizedBox(
              child: Text('${garage.unoccupiedLots}/${garage.parkingLots}'),
            ),
          ],
        ),
      ),
      onTap: () {
        context.push('/home/garage-info/${garage.id}');
      },
    );
  }
}
