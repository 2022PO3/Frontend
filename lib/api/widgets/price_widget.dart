import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/models/enums.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.price,
  }) : super(key: key);
  final Price price;

  @override
  Widget build(BuildContext context) {
    return Text(
      'For ${price.priceString} ${Valuta.getValutaSymbol(price.valuta)} ${price.price} ',
    );
  }
}
