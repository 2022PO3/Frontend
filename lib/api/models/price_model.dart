import 'package:po_frontend/api/models/enums.dart';
import '../network/network_exception.dart';

/// Model which represents the backend `Price`-model.
class Price {
  final int id;
  final int garageId;
  final String priceString;
  final double price;
  final Duration duration;
  final ValutaEnum valuta;

  Price({
    required this.id,
    required this.garageId,
    required this.priceString,
    required this.price,
    required this.duration,
    required this.valuta,
  });

  /// Serializes a JSON-object into a Dart `Price`-object with all properties.
  static Price fromJSON(Map<String, dynamic> json) {
    return Price(
      id: json['id'] as int,
      garageId: json['garageId'] as int,
      priceString: json['priceString'] as String,
      price: json['price'] as double,
      duration: parseDuration(json['duration'] as String),
      valuta: Valuta.toValutaEnum(json['valuta']) ??
          (throw BackendException(
            ['No valid province given.'],
          )),
    );
  }

  /// Serializes a Dart `Price`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(Price price) => <String, dynamic>{
        'id': price.id,
        'garageId': price.garageId,
        'priceString': price.priceString,
        'price': price.price,
        'duration': price.duration.inSeconds,
        'valuta': price.valuta.toString(),
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
