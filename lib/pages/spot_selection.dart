import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/requests/parking_lots_requests.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';

class Spot_Selection extends StatefulWidget {
  const Spot_Selection({Key? key}) : super(key: key);
  @override
  State<Spot_Selection> createState() => _Spot_SelectionState();
}

class _Spot_SelectionState extends State<Spot_Selection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Garage garage = arguments['selected_garage'];
    final DateTime _date = arguments['selected_startdate'];
    final DateTime _date2 = arguments['selected_enddate'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Selection'),
      ),
      body: FutureBuilder(
        future: getGarageParkingLots(garage.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<ParkingLot> parkingLots =
                snapshot.data as List<ParkingLot>;

            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  child: ParkingLotsWidget(parking_lot: parkingLots[index]),
                  onTap: () {
                    parkingLots[index].occupied
                        ? showSpotErrorPopUp(context)
                        : Navigator.pushNamed(
                            context,
                            '/Confirm_Reservation',
                            arguments: {
                              'selected_garage': garage,
                              'selected_startdate': _date,
                              'selected_enddate': _date2,
                              'selected_spot': parkingLots[index],
                            },
                          );
                  },
                );
              },
              itemCount: parkingLots.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.error.toString(),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

void showSpotErrorPopUp(BuildContext context) {
  // set up the buttons
  Widget backButton = TextButton(
    child: const Text('Back'),
    onPressed: () {
      context.pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text('This spot is occupied.'),
    actions: [
      backButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
