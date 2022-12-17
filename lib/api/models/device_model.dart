/// Model which represents the backend `Device`-model.
class Device {
  final int id;
  final String name;
  final bool confirmed;

  Device({
    required this.id,
    required this.name,
    required this.confirmed,
  });

  /// Serializes a JSON-object into a Dart `Device`-object with all properties.
  static Device fromJSON(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      name: json['name'] as String,
      confirmed: json['confirmed'] as bool,
    );
  }

  /// Serializes a Dart `Device`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'name': name,
      };

  /// Serializes a list JSON-objects into a list of Dart `Device`-objects.
  static List<Device> listFromJSON(List<dynamic> json) =>
      (json).map((jsonDevice) => Device.fromJSON(jsonDevice)).toList();
}
