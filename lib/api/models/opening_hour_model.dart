/// Model which represents the backend `Price`-model.
class OpeningHour {
  final int id;
  final int garageId;
  final int fromDay;
  final int toDay;
  final String fromHour;
  final String toHour;

  OpeningHour(
      {required this.id,
      required this.garageId,
      required this.fromDay,
      required this.toDay,
      required this.fromHour,
      required this.toHour});

  /// Serializes a JSON-object into a Dart `Location`-object with all properties.
  static OpeningHour fromJSON(Map<String, dynamic> json) {
    return OpeningHour(
      id: json['id'] as int,
      garageId: json['garageId'] as int,
      fromDay: json['fromDay'] as int,
      toDay: json['toDay'] as int,
      fromHour: json['fromHour'] as String,
      toHour: json['toHour'] as String,
    );
  }

  /// Serializes a Dart `Location`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(OpeningHour openingHour) =>
      <String, dynamic>{
        'id': openingHour.id,
        'garageId': openingHour.garageId,
        'fromDay': openingHour.fromDay,
        'toDay': openingHour.toDay,
        'fromHour': openingHour.fromHour,
        'toHour': openingHour.toHour,
      };
}
