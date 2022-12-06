import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';

class My_Reservations extends StatefulWidget {
  @override
  State<My_Reservations> createState() => _My_ReservationsState();
}

class _My_ReservationsState extends State<My_Reservations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reservations"),
      ),
      //Table of reservations
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<Reservation> reservations =
                snapshot.data as List<Reservation>;

            return ListView.builder(
              itemBuilder: (context, index) {
                return ReservationWidget(reservation: reservations[index]);
              },
              itemCount: reservations.length,
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
                  Text(snapshot.error.toString()),
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

Future<List<Reservation>> getData() async {
  print("Executing function");
  final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug: StaticValues.getReservationSlug,
      useAuthToken: true
      //    body: body
      );

  print("reponse $response");
  print('Response ${response?.body}');
  print('Response status code ${response?.statusCode}');

  return await NetworkHelper.filterResponse(
    callBack: reservationListFromJson,
    response: response,
  );
}