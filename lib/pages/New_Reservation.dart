import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/pages/Spot_Selection.dart';

class New_Reservation extends StatefulWidget {
  const New_Reservation({Key? key}) : super(key: key);
  @override
  State<New_Reservation> createState() => _New_ReservationState();
}

class _New_ReservationState extends State<New_Reservation> {
  List<String> list = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '0'
  ];
  DateTime _date = DateTime.now();
  DateTime _date2 = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Garage garage = arguments['garage'];

    return Scaffold(
      appBar: AppBar(
        title: Text('New Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Please pick a time and date:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("From:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2022, 11, 10),
                          maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          _date = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      _date.toString().substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: Colors.white,
                              ),
                              Text(
                                _date.toString().substring(10, 16),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                          Icon(
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
                  Text("Until:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2022, 11, 1),
                          maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          _date2 = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      _date2.toString().substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: Colors.white,
                              ),
                              Text(
                                _date2.toString().substring(10, 16),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                          Icon(
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
                        print(_date.toString());
                        compareDates(_date, _date2)
                            ? Navigator.pushNamed(context, '/Spot_Selection',
                                arguments: {
                                    'selected_garage': garage,
                                    'selected_startdate': _date,
                                    'selected_enddate': _date2
                                  })
                            : showDateErrorPopUp(context);
                        ;
                        //Checks for correct date and time, start and end !!! and availability of spots at the time
                      },
                      child: Text(
                        "Random spot",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Text("   "),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        compareDates(_date, _date2)
                            ? Navigator.pushNamed(context, '/Spot_Selection',
                                arguments: {
                                    'selected_garage': garage,
                                    'selected_startdate': _date,
                                    'selected_enddate': _date2
                                  })
                            : showDateErrorPopUp(context);

                        ;
                        //Checks for correct date and time, start and end !!! and availability of spots at the time
                      },
                      child: Text(
                        "Select a spot",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    child: Text("Back"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(
        "One of the times is before the current time and date, or the second time and date is before the first"),
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
