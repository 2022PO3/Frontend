// Project imports:
import 'package:po_frontend/api/models/enums.dart';

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

  @override
  String toString() {
    return '$street $number, $municipality, $country';
  }

  bool get isValid => (country != '' &&
      municipality != '' &&
      postCode > 1000 &&
      postCode < 9999 &&
      street != '' &&
      number > 0);

  Location copyWith({
    int? id,
    String? country,
    ProvinceEnum? province,
    String? municipality,
    int? postCode,
    String? street,
    int? number,
  }) {
    return Location(
      id: id ?? this.id,
      country: country ?? this.country,
      province: province ?? this.province,
      municipality: municipality ?? this.municipality,
      postCode: postCode ?? this.postCode,
      street: street ?? this.street,
      number: number ?? this.number,
    );
  }

  /// Serializes a JSON-object into a Dart `Location`-object with all properties.
  static Location fromJSON(Map<String, dynamic> json) {
    return Location(
        id: json['id'] as int,
        country: json['country'] as String,
        province: ProvinceEnum.fromString(json['province'] as String),
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
        'province': location.province.databaseValue,
        'municipality': location.municipality,
        'postCode': location.postCode,
        'street': location.street,
        'number': location.number
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Location &&
        other.id == id &&
        other.country == country &&
        other.province == province &&
        other.municipality == municipality &&
        other.postCode == postCode &&
        other.street == street &&
        other.number == number;
  }

  @override
  int get hashCode => Object.hash(
        id,
        country,
        province.index,
        municipality,
        postCode,
        street,
        number,
      );
}
