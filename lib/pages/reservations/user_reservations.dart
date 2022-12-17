import 'package:flutter/material.dart';

import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/requests/reservation_requests.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/core/app_bar.dart';

class UserReservations extends StatefulWidget {
  const UserReservations({super.key});

  @override
  State<UserReservations> createState() => _UserReservationsState();
}

class _UserReservationsState extends State<UserReservations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'My reservations',
        refreshButton: true,
        refreshFunction: () => setState(() => {}),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => {});
        },
        child: FutureBuilder(
          future: getReservations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Reservation> reservations =
                  snapshot.data as List<Reservation>;

              List<Reservation> doneReservations = reservations
                  .where((r) => DateTime.now().isAfter(r.toDate))
                  .toList();

              List<Reservation> activeReservations = reservations
                  .where((r) => !DateTime.now().isAfter(r.toDate))
                  .toList();

              doneReservations.sort(
                (r1, r2) => r1.fromDate.millisecondsSinceEpoch
                    .compareTo(r2.fromDate.millisecondsSinceEpoch),
              );

              activeReservations.sort(
                (r1, r2) => r1.fromDate.millisecondsSinceEpoch
                    .compareTo(r2.fromDate.millisecondsSinceEpoch),
              );

              List<Reservation> allReservations = activeReservations
                ..addAll(doneReservations);

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics().applyTo(
                  const BouncingScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  return ReservationWidget(reservation: allReservations[index]);
                },
                itemCount: allReservations.length,
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
      ),
    );
  }
}
