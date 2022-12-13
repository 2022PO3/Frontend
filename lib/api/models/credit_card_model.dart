import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:po_frontend/utils/user_data.dart';

/// Model which represents the backend `Card`-model.
class CreditCard {
  final String number;
  final int? expMonth;
  final int? expYear;
  final String cvc;

  CreditCard({
    required this.number,
    this.expMonth,
    this.expYear,
    required this.cvc,
  });

  factory CreditCard.empty(BuildContext context) {
    final String name =
        '${getUserFirstName(context)} ${getUserLastName(context)}';
    return CreditCard(
      number: '',
      cvc: '',
    );
  }

  factory CreditCard.fromCardFormCreditCardModel(
      CreditCardModel creditCardModel) {
    String expiryDate = creditCardModel.expiryDate;
    List<String> splitted = expiryDate.split('/');
    int? expMonth;
    int? expYear;
    if (splitted.isNotEmpty) {
      expMonth = int.tryParse(splitted[0]);
    }
    if (splitted.length > 1) {
      expYear = int.tryParse(splitted[1]);
      expYear = (expYear != null) ? expYear + 2000 : null;
    }

    return CreditCard(
      number: creditCardModel.cardNumber,
      cvc: creditCardModel.cvvCode,
      expMonth: expMonth,
      expYear: expYear,
    );
  }

  String get shortExpDate {
    String expDate = '';
    if (expMonth != null) {
      expDate += '$expMonth';
    }
    if (expYear != null) {
      expDate += '/${expYear! - 2000}';
    }
    return expDate;
  }

  /// Serializes a JSON-object into a Dart `Card`-object with all properties.
  static CreditCard fromJSON(Map<String, dynamic> json) {
    return CreditCard(
      number: json['number'] as String,
      expMonth: json['expMonth'] as int,
      expYear: json['expYear'] as int,
      cvc: json['cvc'] as String,
    );
  }

  /// Serializes a Dart `Card`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'number': number,
        'expMonth': expMonth,
        'expYear': expYear,
        'cvc': cvc,
      };

  /// Serializes a list JSON-objects into a list of Dart `Card`-objects.
  static List<CreditCard> listFromJSON(List<dynamic> json) =>
      (json).map((jsonCard) => CreditCard.fromJSON(jsonCard)).toList();
}
