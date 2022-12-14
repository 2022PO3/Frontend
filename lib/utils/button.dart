import 'package:flutter/material.dart';
import 'package:po_frontend/utils/constants.dart';

Widget buildButton(
  String text,
  Color color,
  Function onPressed,
) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Constants.borderRadius,
              ),
            ),
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
  );
}
