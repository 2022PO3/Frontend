// Project imports:
import 'package:po_frontend/api/models/enums.dart';

/// Model which represents the backend `Price`-model.
class Price {
  final int id;
  final String priceString;
  final double price;
  final Duration duration;
  final ValutaEnum valuta;

  Price({
    required this.id,
    required this.priceString,
    required this.price,
    required this.duration,
    required this.valuta,
  });

  Price copyWith({
    int? id,
    int? garageId,
    String? priceString,
    double? price,
    Duration? duration,
    ValutaEnum? valuta,
  }) {
    return Price(
        id: id ?? this.id,
        priceString: priceString ?? this.priceString,
        price: price ?? this.price,
        duration: duration ?? this.duration,
        valuta: valuta ?? this.valuta);
  }

  /// Serializes a JSON-object into a Dart `Price`-object with all properties.
  static Price fromJSON(Map<String, dynamic> json) {
    return Price(
      id: json['id'] as int,
      priceString: json['priceString'] as String,
      price: json['price'] as double,
      duration: parseDuration(json['duration'] as String),
      valuta: ValutaEnum.fromString(json['valuta'] as String),
    );
  }

  /// Serializes a Dart `Price`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'priceString': priceString,
        'price': price,
        'duration': duration.inSeconds,
        'valuta': valuta.databaseValue,
      };

  static List<Price> listFromJSON(List<dynamic> json) =>
      (json).map((jsonPrice) => Price.fromJSON(jsonPrice)).toList();
}

Duration parseDuration(String s) {
  List<String> parts = s.split(':');
  return Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
    seconds: int.parse(
      parts[2],
    ),
  );
}
