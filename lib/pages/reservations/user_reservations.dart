import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';

class UserReservations extends StatefulWidget {
  const UserReservations({super.key});

  @override
  State<UserReservations> createState() => _UserReservationsState();
}

class _UserReservationsState extends State<UserReservations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations'),
      ),
      body: FutureBuilder(
        future: getReservations(),
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