import 'package:flutter/material.dart';

Widget buildCard(String text) {
  return Card(
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
