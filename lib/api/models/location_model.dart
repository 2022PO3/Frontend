import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/network/network_exception.dart';

/// Model which represents the backend `Location`-model.
class Location {
  final int id;
  final String country;
  final ProvinceEnum province;
  final String municipality;
  final int postCode;
  final String street;
  final int number;

  Location({
    required this.id,
    required this.country,
    required this.province,
    required this.municipality,
    required this.postCode,
    required this.street,
    required this.number,
  });

  /// Serializes a JSON-object into a Dart `Location`-object with all properties.
  static Location fromJSON(Map<String, dynamic> json) {
    ProvinceEnum? province =
        Province.toProvinceEnum(json['province'] as String);
    return Location(
        id: json['id'] as int,
        country: json['country'] as String,
        province:
            province ?? (throw BackendException(['No valid province given.'])),
        municipality: json['municipality'] as String,
        postCode: json['postCode'] as int,
        street: json['street'] as String,
        number: json['number'] as int);
  }

  /// Serializes a Dart `Location`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(Location location) => <String, dynamic>{
        'id': location.id,
        'country': location.country,
        'province': location.province.toString(),
        'municipality': location.municipality,
        'postcode': location.postCode,
        'street': location.street,
        'number': location.number
      };
}
