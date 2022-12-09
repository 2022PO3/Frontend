import 'package:po_frontend/api/models/garage_settings_model.dart';

/// Model which represents the backend `Garage`-model.
class Garage {
  final int id;
  final String name;
  final bool isFull;
  final int unoccupiedLots;
  final int parkingLots;
  final GarageSettings garageSettings;

  Garage({
    required this.id,
    required this.name,
    required this.isFull,
    required this.unoccupiedLots,
    required this.parkingLots,
    required this.garageSettings,
  });

  /// Serializes a JSON-object into a Dart `Garage`-object with all properties.
  static Garage fromJSON(Map<String, dynamic> json) {
    return Garage(
        id: json['id'] as int,
        name: json['name'] as String,
        isFull: json['isFull'] as bool,
        unoccupiedLots: json['unoccupiedLots'] as int,
        parkingLots: json['parkingLots'] as int,
        garageSettings: GarageSettings.fromJSON(
            json['garageSettings'] as Map<String, dynamic>));
  }

  /// Serializes a Dart `Garage`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'garageSettings': GarageSettings.toJSON(garageSettings),
      };

  /// Serializes a list JSON-objects into a list of Dart `Garage`-objects.
  static List<Garage> listFromJSON(List<dynamic> json) =>
      (json).map((jsonGarage) => Garage.fromJSON(jsonGarage)).toList();
}
