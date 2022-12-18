// Project imports:
import 'package:po_frontend/api/models/base_model.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';
import 'package:po_frontend/api/network/static_values.dart';

/// Model which represents the backend 'Reservation'-model
class Reservation extends BaseModel {
  final LicencePlate licencePlate;
  final Garage garage;
  final DateTime fromDate;
  final DateTime toDate;
  final ParkingLot parkingLot;

  Reservation({
    required id,
    required this.licencePlate,
    required this.fromDate,
    required this.toDate,
    required this.parkingLot,
    required this.garage,
  }) : super(id: id, detailSlug: StaticValues.reservationDetailSlug);

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'garageId': garage.id,
        'licencePlateId': licencePlate.id,
        'fromDate': fromDate.toIso8601String(),
        'toDate': toDate.toIso8601String(),
        'parkingLotId': parkingLot.id,
      };

  static Reservation fromJSON(Map<String, dynamic> json) {
    return Reservation(
        id: json['id'] as int,
        licencePlate: LicencePlate.fromJSON(json['licencePlate']),
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
