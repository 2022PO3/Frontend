import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:po_frontend/api/models/enums.dart';
class CurrentPrice extends StatelessWidget {
  CurrentPrice({Key? key, required this.curprice}) : super(key: key);
  final Price? curprice;

  @override
  Widget build(BuildContext context) {
    return Text(
      "for " + curprice!.priceString + " " + curprice!.price.toString() + " " + Valuta().getValutaSymbol(curprice!.valuta)  //curprice!.valuta
    );
  }
}