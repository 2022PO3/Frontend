// Project imports:
import 'package:po_frontend/api/models/base_model.dart';
import 'package:po_frontend/api/network/static_values.dart';

/// Model which represents the backend `Device`-model.
class LicencePlate extends BaseModel {
  final String licencePlate;
  final int? garageId;
  final DateTime? enteredAt;
  final DateTime? paidAt;
  final bool enabled;

  LicencePlate({
    required id,
    required this.licencePlate,
    required this.garageId,
    this.enteredAt,
    this.paidAt,
    required this.enabled,
  })  : assert(
          garageId == null ? enteredAt == null : enteredAt != null,
        ),
        super(id: id, detailSlug: StaticValues.licencePlatesDetailSlug);

  /// Serializes a JSON-object into a Dart `LicencePlate`-object with all properties.
  static LicencePlate fromJSON(Map<String, dynamic> json) {
    return LicencePlate(
      id: json['id'] as int,
      licencePlate: json['licencePlate'] as String,
      garageId: json['garageId'] as int?,
      enteredAt:
          json['enteredAt'] != null ? DateTime.parse(json['enteredAt']) : null,
      paidAt:
          json['paidAt'] != null ? DateTime.parse(json['paidAtpaidAt']) : null,
      enabled: json['enabled'],
    );
  }

  /// Serializes a Dart `LicencePlate`-object to a JSON-object with the attributes defined in
  /// the database.
  @override
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'licence_plate': licencePlate,
        'garage_id': garageId,
        'enabled': enabled,
      };

  String formatLicencePlate() {
    return '${licencePlate.substring(0, 1)}-${licencePlate.substring(1, 4)}-${licencePlate.substring(4)}';
  }

  /// Serializes a list JSON-objects into a list of Dart `Device`-objects.
  static List<LicencePlate> listFromJSON(List<dynamic> json) =>
      (json).map((jsonDevice) => LicencePlate.fromJSON(jsonDevice)).toList();
}
