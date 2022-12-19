// Project imports:
import 'package:po_frontend/api/models/base_model.dart';
import 'package:po_frontend/api/models/garage_settings_model.dart';
import 'package:po_frontend/api/models/parking_lot_model.dart';

import 'package:flutter/services.dart';

/// Model which represents the backend `Garage`-model.
class Garage extends BaseModel {
  final int userId;
  final String name;
  final List<ParkingLot> parkingLots;
  final GarageSettings garageSettings;
  final int entered;
  final int reservations;

  Garage({
    required id,
    required this.userId,
    required this.name,
    required this.parkingLots,
    required this.garageSettings,
    required this.entered,
    required this.reservations,
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
        parkingLots: parkingLots,
        garageSettings: garageSettings ?? this.garageSettings,
        entered: entered,
        reservations: reservations);
  }

  /// Serializes a JSON-object into a Dart `Garage`-object with all properties.
  static Garage fromJSON(Map<String, dynamic> json) {
    return Garage(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
      parkingLots: ParkingLot.listFromJSON(json['parkingLots']),
      garageSettings: GarageSettings.fromJSON(
        json['garageSettings'] as Map<String, dynamic>,
      ),
      entered: json['entered'],
      reservations: json['reservations'],
    );
  }

  int get maxSpots => parkingLots.length;
  int get occupiedLots => reservations + entered;
  int get disabledLots => parkingLots.where((pl) => pl.disabled).length;
  int get unoccupiedLots => maxSpots - occupiedLots - disabledLots;
  bool get isFull => maxSpots == occupiedLots;

  //final double bookedLots = parkingLots.where((pl) => pl.booked ?? false );

  /// Serializes a Dart `Garage`-object to a JSON-object with the attributes defined in
  /// the database.
  @override
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
        'garageSettings': GarageSettings.toJSON(garageSettings),
      };

  /// Serializes a list JSON-objects into a list of Dart `Garage`-objects.
  static List<Garage> listFromJSON(List<dynamic> json) =>
      (json).map((jsonGarage) => Garage.fromJSON(jsonGarage)).toList();
}
