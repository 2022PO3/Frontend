import 'package:po_frontend/api/models/enums.dart';

/// Model which represents the backend `Price`-model.
class Price {
  final int id;
  final int garageId;
  final String priceString;
  final double price;
  final ValutaEnum valuta;

  Price({
    required this.id,
    required this.garageId,
    required this.priceString,
    required this.price,
    required this.valuta,
  });

  /// Serializes a JSON-object into a Dart `Location`-object with all properties.
  static Price fromJSON(Map<String, dynamic> json) {
    return Price(
      id: json['id'] as int,
      garageId: json['garageId'] as int,
      priceString: json['priceString'] as String,
      price: json['price'] as double,
      valuta: json['valuta'] as ValutaEnum,
    );
  }

  /// Serializes a Dart `Location`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(Price openingHour) => <String, dynamic>{
        'id': openingHour.id,
        'garageId': openingHour.garageId,
        'priceString': openingHour.priceString,
        'price': openingHour.price,
        'valuta': openingHour.valuta.toString(),
      };
}
