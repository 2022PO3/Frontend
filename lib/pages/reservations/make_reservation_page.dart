import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';

class MakeReservationPage extends StatefulWidget {
  const MakeReservationPage({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;
  @override
  State<MakeReservationPage> createState() => _MakeReservationPageState();
}

class _MakeReservationPageState extends State<MakeReservationPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<String> range(int from, int to) {
      return List.generate(to - from + 1, (i) => (i + from).toString());
    }

    List<String> hours = range(1, 23);
    hours.add('0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text('Please pick a time and date:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'From:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      theme: const DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2022, 11, 10),
                      maxTime: DateTime(2030, 12, 31),
                      onConfirm: (date) {
                        setState(
                          () {
                            startDate = date;
                          },
                        );
                      },
                      currentTime: startDate,
                      locale: LocaleType.en,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  startDate.toString().substring(0, 10),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            Text(
                              startDate.toString().substring(10, 16),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.edit,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Until:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      theme: const DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2022, 11, 1),
                      maxTime: DateTime(2030, 12, 31),
                      onConfirm: (date) {
                        setState(() {
                          endDate = date;
                        });
                      },
                      currentTime: endDate,
                      locale: LocaleType.en,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  endDate.toString().substring(0, 10),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            Text(
                              endDate.toString().substring(10, 16),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.edit,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    onPressed: () {
                      compareDates(startDate, endDate)
                          ? context.push(
                              '/home/garage-info/${widget.garage.id}/reserve/spot-selection',
                              extra: GarageAndTime(
                                garage: widget.garage,
                                startDate: startDate,
                                endDate: endDate,
                              ),
                            )
                          : showDateErrorPopUp(context);
                      //Checks for correct date and time, start and end !!! and availability of spots at the time
                    },
                    child: const Text(
                      'Random spot',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const Text('   '),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    onPressed: () {
                      compareDates(startDate, endDate)
                          ? context.push(
                              '/home/reserve/spot-selection',
                              extra: GarageAndTime(
                                garage: widget.garage,
                                startDate: startDate,
                                endDate: endDate,
                              ),
                            )
                          : showDateErrorPopUp(context);
                    },
                    child: const Text(
                      'Select a spot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  var now = DateTime.now();
  bool compareDates(DateTime date, DateTime date2) {
    now = DateTime.now();
    if (now.compareTo(date) > 0) {
      return false;
    }
    if (now.compareTo(date2) > 0) {
      return false;
    }
    if (date.compareTo(date2) > 0) {
      return false;
    }
    return true;
  }
}

void showDateErrorPopUp(BuildContext context) {
  // set up the buttons
  Widget backButton = TextButton(
    child: const Text('Back'),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text(
      'One of the times is before the current time and date, or the second time and date is before the first',
    ),
    actions: [
      backButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class GarageAndTime {
  const GarageAndTime({
    Key? key,
    required this.garage,
    required this.startDate,
    required this.endDate,
  });

  final Garage garage;
  final DateTime startDate;
  final DateTime endDate;
}