// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:po_frontend/api/models/opening_hour_model.dart';

class OpeningHourWidget extends StatelessWidget {
  OpeningHourWidget({
    Key? key,
    required this.openingHours,
  }) : super(key: key);
  final OpeningHour openingHours;
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
    final DateFormat dayFormat = DateFormat('y-M-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');
    final String today = dayFormat.format(DateTime.now());

    List<Widget> list = [];
    for (var i = openingHours.fromDay; i <= openingHours.toDay; i++) {
      final DateTime openingHourFrom = DateTime.parse(
        '$today ${openingHours.fromHour}',
      );
      final DateTime openingHourTo = DateTime.parse(
        '$today ${openingHours.toHour}',
      );
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${weekdays[i]}:',
            ),
            Text(
              '${timeFormat.format(openingHourFrom)}-${timeFormat.format(openingHourTo)}',
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: list,
    );
  }
}
