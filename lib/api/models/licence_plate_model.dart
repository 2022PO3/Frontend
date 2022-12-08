/// Model which represents the backend `Device`-model.
class LicencePlate {
  final int id;
  final String licencePlate;
  final int? garageId;
  final int userId;
  final DateTime updatedAt;

  LicencePlate(
      {required this.id,
      required this.licencePlate,
      required this.garageId,
      required this.userId,
      required this.updatedAt});

  /// Serializes a JSON-object into a Dart `Device`-object with all properties.
  static LicencePlate fromJSON(Map<String, dynamic> json) {
    print(json);
    return LicencePlate(
        id: json['id'] as int,
        licencePlate: json['licencePlate'] as String,
        garageId: json['garageId'] as int?,
        userId: json['userId'] as int,
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  /// Serializes a Dart `Device`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(LicencePlate licencePlate) =>
      <String, dynamic>{
        'id': licencePlate.id,
        'licence_plate': licencePlate.licencePlate,
        'garage_id': licencePlate.garageId,
        'user_id': licencePlate.userId,
      };

  /// Serializes a list JSON-objects into a list of Dart `Device`-objects.
  static List<LicencePlate> listFromJSON(List<dynamic> json) =>
      (json).map((jsonDevice) => LicencePlate.fromJSON(jsonDevice)).toList();
}
