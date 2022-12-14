import 'package:flutter/material.dart';
import 'package:po_frontend/utils/constants.dart';

Widget buildCard(String text) {
  return Card(
    shape: Constants.cardBorder,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    ),
  );
}
