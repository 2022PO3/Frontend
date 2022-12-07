import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';

class GarageOpeningHoursWidget extends StatelessWidget {
  GarageOpeningHoursWidget({Key? key, required this.openingsHours})
      : super(key: key);
  final OpeningHour? openingsHours;
  final List weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = openingsHours!.fromDay; i <= openingsHours!.toDay; i++) {
      list.add(Text(
        weekdays[i] +
            ': open from ' +
            openingsHours?.fromHour.toString() +
            ' until ' +
            openingsHours?.toHour.toString(),
        style: const TextStyle(
          color: Colors.indigo,
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }
}
