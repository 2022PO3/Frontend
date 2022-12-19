/// Model which represents the backend `OpeningHour`-model.
class OpeningHour {
  final int id;
  final int fromDay;
  final int toDay;
  final String fromHour;
  final String toHour;

  OpeningHour(
      {required this.id,
      required this.fromDay,
      required this.toDay,
      required this.fromHour,
      required this.toHour});

  /// Serializes a JSON-object into a Dart `OpeningHour`-object with all properties.
  static OpeningHour fromJSON(Map<String, dynamic> json) {
    return OpeningHour(
      id: json['id'] as int,
      fromDay: json['fromDay'] as int,
      toDay: json['toDay'] as int,
      fromHour: json['fromHour'] as String,
      toHour: json['toHour'] as String,
    );
  }

  /// Serializes a Dart `OpeningHour`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON(OpeningHour openingHour) => <String, dynamic>{
        'id': openingHour.id,
        'fromDay': openingHour.fromDay,
        'toDay': openingHour.toDay,
        'fromHour': openingHour.fromHour,
        'toHour': openingHour.toHour,
      };
  static List<OpeningHour> listFromJSON(List<dynamic> json) => (json)
      .map((jsonOpeningHour) => OpeningHour.fromJSON(jsonOpeningHour))
      .toList();
}
