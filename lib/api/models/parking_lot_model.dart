/// Model which represents the backend `ParkingLot`-model.
class ParkingLot {
  final int id;
  final int garageId;
  final int floorNumber;
  final bool occupied;
  final int parkingLotNo;
  final bool? booked;

  ParkingLot({
    required this.id,
    required this.garageId,
    required this.floorNumber,
    required this.occupied,
    required this.parkingLotNo,
    required this.booked,
  });

  static ParkingLot fromJSON(Map<String, dynamic> json) {
    return ParkingLot(
      id: json['id'] as int,
      garageId: json['garageId'] as int,
      floorNumber: json['floorNumber'] as int,
      occupied: json['occupied'] as bool,
      parkingLotNo: json['parkingLotNo'] as int,
      booked: json['booked'] as bool?,
    );
  }

  static Map<String, dynamic> toJSON(ParkingLot parkingLot) =>
      <String, dynamic>{
        'id': parkingLot.id,
        'garageId': parkingLot.garageId,
        'floorNumber': parkingLot.floorNumber,
        'occupied': parkingLot.occupied
      };

  static List<ParkingLot> listFromJSON(json) => (json as List)
      .map(
        (jsonParkingLot) => ParkingLot.fromJSON(
          jsonParkingLot as Map<String, dynamic>,
        ),
      )
      .toList();
}
