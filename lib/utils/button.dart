import 'package:flutter/material.dart';

Widget buildButton(
  String text,
  Color color,
  Function onPressed,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 5,
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
            ),
            onPressed: () {
              onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
