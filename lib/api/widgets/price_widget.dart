// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/api/models/price_model.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.price,
  }) : super(key: key);
  final Price price;

  @override
  Widget build(BuildContext context) {
    return Text(
      'For ${price.priceString} ${price.valuta.toString()} ${price.price} ',
    );
  }
}
