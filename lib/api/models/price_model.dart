import 'package:po_frontend/api/models/enums.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../network/network_exception.dart';
import 'enums.dart';
import 'enums.dart';

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

  /// Serializes a JSON-object into a Dart `Price`-object with all properties.
  static Price fromJSON(Map<String, dynamic> json) {
    return Price(
      id: json['id'] as int,
      garageId: json['garageId'] as int,
      priceString: json['priceString'] as String,
      price: json['price'] as double,
      valuta: Valuta.toValutaEnum(json['valuta']) ?? (throw BackendException(['No valid province given.'])),
    );
  }

  /// Serializes a Dart `Price`-object to a JSON-object with the attributes defined in
  /// the database.
  static Map<String, dynamic> toJSON(Price openingHour) => <String, dynamic>{
        'id': openingHour.id,
        'garageId': openingHour.garageId,
        'priceString': openingHour.priceString,
        'price': openingHour.price,
        'valuta': openingHour.valuta.toString(),
      };
}

List<Price> PriceListFromJson(List<dynamic> json) =>
    (json).map((jsonprice) => Price.fromJSON(jsonprice)).toList();
