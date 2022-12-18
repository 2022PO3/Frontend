// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/api/requests/reservation_requests.dart';
import 'package:po_frontend/api/widgets/reservation_widget.dart';
import 'package:po_frontend/utils/item_widgets.dart';

class UserReservations extends StatefulWidget {
  const UserReservations({super.key});

  @override
  State<UserReservations> createState() => _UserReservationsState();
}

class _UserReservationsState extends State<UserReservations> {
  @override
  Widget build(BuildContext context) {
    return buildEditItemsScreen<Reservation>(
      title: 'Reservations',
      future: handleGetReservations(),
      itemWidget: buildReservationWidget,
      refreshFunction: () async {
        setState(() => {});
      },
    );
  }
}

Future<List<Reservation>> handleGetReservations() async {
  List<Reservation> reservations = await getReservations();

  List<Reservation> doneReservations = reservations
      .where(
        (r) => DateTime.now().isAfter(r.toDate),
      )
      .toList();

  List<Reservation> activeReservations = reservations
      .where(
        (r) => !DateTime.now().isAfter(r.toDate),
      )
      .toList();

  doneReservations.sort(
    (r1, r2) => r1.fromDate.millisecondsSinceEpoch.compareTo(
      r2.fromDate.millisecondsSinceEpoch,
    ),
  );

  activeReservations.sort(
    (r1, r2) => r1.fromDate.millisecondsSinceEpoch.compareTo(
      r2.fromDate.millisecondsSinceEpoch,
    ),
  );

  return activeReservations..addAll(doneReservations);
}
