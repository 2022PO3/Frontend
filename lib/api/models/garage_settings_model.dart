import 'package:po_frontend/api/models/location_model.dart';

/// Model which represents the backend `GarageSettings`-model.
class GarageSettings {
  final int id;
  final Location location;
  final int electricCars;
  final double maxHeight;
  final double maxWidth;
  final int maxHandicappedLots;

  GarageSettings({
    required this.id,
    required this.location,
    required this.electricCars,
    required this.maxHeight,
    required this.maxWidth,
    required this.maxHandicappedLots,
  });

  GarageSettings copyWith({
    int? id,
    Location? location,
    int? electricCars,
    double? maxHeight,
    double? maxWidth,
    int? maxHandicappedLots,
  }) {
    return GarageSettings(
      id: id ?? this.id,
      location: location ?? this.location,
      electricCars: electricCars ?? this.electricCars,
      maxHeight: maxHeight ?? this.maxHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHandicappedLots: maxHandicappedLots ?? this.maxHandicappedLots,
    );
  }

  /// Serializes a JSON-object into a Dart `GarageSettings`-object with all properties.
  static GarageSettings fromJSON(Map<String, dynamic> json) {
    return GarageSettings(
      id: json['id'] as int,
      location: Location.fromJSON(json['location'] as Map<String, dynamic>),
      electricCars: json['electricCars'] as int,
      maxHeight: json['maxHeight'] as double,
      maxWidth: json['maxWidth'] as double,
      maxHandicappedLots: json['maxHandicappedLots'] as int,
    );
  }

  /// Serializes a Dart `GarageSettings`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(GarageSettings garageSettings) =>
      <String, dynamic>{
        'id': garageSettings.id,
        'location': Location.toJSON(garageSettings.location),
        'electricCars': garageSettings.electricCars,
        'maxHeight': garageSettings.maxHeight,
        'maxWidth': garageSettings.maxWidth,
        'maxHandicappedLots': garageSettings.maxHandicappedLots,
      };
}
