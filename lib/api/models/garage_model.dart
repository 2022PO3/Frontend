/// Model which represents the backend `Garage`-model.
class Garage {
  final int id;
  final int owner;
  final String name;
  final bool isFull;
  final int unoccupiedLots;
  final int parkingLots;

  Garage(
      {required this.id,
      required this.owner,
      required this.name,
      required this.isFull,
      required this.unoccupiedLots,
      required this.parkingLots});

  /// Serializes a JSON-object into a Dart `Garage`-object with all properties.
  static Garage garageFromJson(Map<String, dynamic> json) {
    return Garage(
        id: json['id'] as int,
        owner: json['ownerId'] as int,
        name: json['name'] as String,
        isFull: json['isFull'] as bool,
        unoccupiedLots: json['unoccupiedLots'] as int,
        parkingLots: json['parkingLots'] as int);
  }

  /// Serializes a Dart `Garage`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> garageToJson(Garage garage) => <String, dynamic>{
        'id': garage.id,
        'owner': garage.owner,
        'name': garage.name,
      };
}

/// Serializes a list JSON-objects into a list of Dart `Garage`-objects.
List<Garage> garagesListFromJson(List<dynamic> json) =>
    (json).map((jsonGarage) => Garage.garageFromJson(jsonGarage)).toList();
