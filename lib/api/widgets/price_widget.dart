import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/models/enums.dart';

class CurrentPrice extends StatelessWidget {
  const CurrentPrice({Key? key, required this.price}) : super(key: key);
  final Price? price;

  @override
  Widget build(BuildContext context) {
    return Text(
      'For ${price!.priceString} ${price!.valuta} ${price!.price} ',
      style: const TextStyle(
        color: Colors.indigo,
      ),
    );
  }
}
