import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/pages/Spot_Selection.dart';
import 'package:po_frontend/api/models/parking_lots_model.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

class Confirm_Reservation extends StatefulWidget {
  const Confirm_Reservation({Key? key}) : super(key: key);
  @override
  State<Confirm_Reservation> createState() => _Confirm_ReservationState();
}

class _Confirm_ReservationState extends State<Confirm_Reservation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Garage garage = arguments['garage'];
    final DateTime _date = arguments['selected_startdate'];
    final DateTime _date2 = arguments['selected_enddate'];
    final ParkingLots parkinglot = arguments['selected_spot'];

    return Scaffold(
      appBar: AppBar(
        title: Text('New Reservation'),
      ),
    );
  }
}
