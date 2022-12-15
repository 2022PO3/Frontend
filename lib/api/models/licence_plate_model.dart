/// Model which represents the backend `Device`-model.
class LicencePlate {
  final int id;
  final String licencePlate;
  final int? garageId;
  final int userId;
  final DateTime updatedAt;
  final bool enabled;

  LicencePlate({
    required this.id,
    required this.licencePlate,
    required this.garageId,
    required this.userId,
    required this.updatedAt,
    required this.enabled,
  });

  /// Serializes a JSON-object into a Dart `Device`-object with all properties.
  static LicencePlate fromJSON(Map<String, dynamic> json) {
    print(json);
    return LicencePlate(
      id: json['id'] as int,
      licencePlate: json['licencePlate'] as String,
      garageId: json['garageId'] as int?,
      userId: json['userId'] as int,
      updatedAt: DateTime.parse(json['updatedAt']),
      enabled: json['enabled'] ?? true,
    );
  }

  /// Serializes a Dart `Device`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'licence_plate': licencePlate,
        'garage_id': garageId,
        'user_id': userId,
        'enabled': enabled,
      };

  String formatLicencePlate() {
    return '${licencePlate.substring(0, 1)}-${licencePlate.substring(1, 4)}-${licencePlate.substring(4)}';
  }

  /// Serializes a list JSON-objects into a list of Dart `Device`-objects.
  static List<LicencePlate> listFromJSON(List<dynamic> json) =>
      (json).map((jsonDevice) => LicencePlate.fromJSON(jsonDevice)).toList();
}
