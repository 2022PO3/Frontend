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
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.indigo[100],
          border: Border.all(color: Colors.indigo.shade100, width: 4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(garage.name,
                    style: TextStyle(
                      color: Colors.indigo.shade800,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Text(garage.isFull ? 'Full' : 'Empty places:',
                    style: TextStyle(
                        color: Colors.indigo.shade800,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Text('${garage.unoccupiedLots}/${garage.parkingLots}',
                    style: TextStyle(
                        color: Colors.indigo.shade800,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
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
      ),
      onTap: () {
        context.push('/home/garage-info/${garage.id}');
      },
    );
  }
}
