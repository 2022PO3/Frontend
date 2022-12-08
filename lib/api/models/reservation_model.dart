import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';

/// Model which represents the backend 'Reservation'-model
class Reservation {
  final int userId;
  final Garage garage;
  final DateTime fromDate;
  final DateTime toDate;
  final ParkingLot parkingLot;

  Reservation({
    required this.userId,
    required this.fromDate,
    required this.toDate,
    required this.parkingLot,
    required this.garage,
  });

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'garageId': garage.id,
        'userId': userId,
        'fromDate': fromDate.toIso8601String(),
        'toDate': toDate.toIso8601String(),
        'parkingLotId': parkingLot.id,
      };

  static Reservation fromJSON(Map<String, dynamic> json) {
    return Reservation(
        userId: json['userId'] as int,
        fromDate: DateTime.parse(json['fromDate']),
        toDate: DateTime.parse(json['toDate']),
        parkingLot: ParkingLot.fromJSON(json['parkingLot']),
        garage: Garage.fromJSON(json['garage']));
  }

  static List<Reservation> listFromJSON(List<dynamic> json) => (json)
      .map(
        (jsonReservation) => Reservation.fromJSON(
          jsonReservation as Map<String, dynamic>,
        ),
      )
      .toList();
}
