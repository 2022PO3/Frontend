import 'package:po_frontend/api/models/garage_model.dart';

//Model which represents the backend 'Reservation'-model
class Reservation {
  final int id;
  final int owner;
  final Garage garage;
  final DateTime fromDate;
  final DateTime toDate;
  final int spot;

  Reservation(
      {required this.owner,
      required this.id,
      required this.fromDate,
      required this.toDate,
      required this.spot,
      required this.garage});

  static Reservation reservationFromJson(Map<String, dynamic> json) {
    return Reservation(
        id: json['id'] as int,
        owner: json['userId'] as int,
        fromDate: DateTime.parse(json['fromDate']),
        toDate: DateTime.parse(json['toDate']),
        spot: json['parkingLotId'] as int,
        garage: Garage.fromJSON(json['garage']));
  }

  static Map<String, dynamic> reservationToJson(Reservation reservation) =>
      <String, dynamic>{
        'id': reservation.id,
        'garage': reservation.garage,
        'userId': reservation.owner,
        'fromDate': reservation.fromDate,
        'toDate': reservation.toDate,
        'parkingLotId': reservation.spot,
      };
}

List<Reservation> reservationListFromJson(List<dynamic> json) => (json)
    .map((jsonReservation) => Reservation.reservationFromJson(
        jsonReservation as Map<String, dynamic>))
    .toList();
