/// Model which represents the backend `Parking lots`-model.
class ParkingLots {
  final int id;
  final int garageId;
  final int floorNumber;
  final bool occupied;
  ParkingLots({
    required this.id,
    required this.garageId,
    required this.floorNumber,
    required this.occupied
});
  static ParkingLots parkingLotsFromJson(Map<String, dynamic> json) {
    return ParkingLots(
        id: json['id'] as int,
        garageId: json['garageId'] as int,
        floorNumber: json['floorNumber'] as int,
        occupied: json['occupied'] as bool
    );
  }
  static Map<String, dynamic> parking_lotsToJson(ParkingLots parking_lot) => <String, dynamic>{
    'id': parking_lot.id,
    'garageId': parking_lot.garageId,
    'floorNumber': parking_lot.floorNumber,
    'occupied': parking_lot.occupied
  };
}

List<ParkingLots> parking_lotsListFromJson(json) => (json as List)
    .map((jsonParking_lot) =>
    ParkingLots.parkingLotsFromJson(jsonParking_lot as Map<String, dynamic>))
    .toList();