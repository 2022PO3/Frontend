// Project imports:
import 'package:po_frontend/api/models/base_model.dart';
import 'package:po_frontend/api/models/garage_settings_model.dart';

/// Model which represents the backend `Garage`-model.
class Garage extends BaseModel {
  final int userId;
  final String name;
  final bool isFull;
  final int unoccupiedLots;
  final int parkingLots;
  final GarageSettings garageSettings;

  Garage({
    required id,
    required this.userId,
    required this.name,
    required this.isFull,
    required this.unoccupiedLots,
    required this.parkingLots,
    required this.garageSettings,
  }) : super(id: id);

  Garage copyWith({
    int? id,
    int? userId,
    String? name,
    GarageSettings? garageSettings,
  }) {
    return Garage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isFull: isFull,
      unoccupiedLots: unoccupiedLots,
      parkingLots: parkingLots,
      garageSettings: garageSettings ?? this.garageSettings,
    );
  }

  /// Serializes a JSON-object into a Dart `Garage`-object with all properties.
  static Garage fromJSON(Map<String, dynamic> json) {
    return Garage(
        id: json['id'] as int,
        userId: json['userId'] as int,
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
