// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/utils/constants.dart';

Widget buildButton(
  String text,
  Color color,
  Function onPressed, {
  bool onlyExpanded = false,
  bool withCardPadding = false,
}) {
  return onlyExpanded
      ? _buildButton(text, color, onPressed)
      : withCardPadding
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [_buildButton(text, color, onPressed)],
              ),
            )
          : Row(
              children: [_buildButton(text, color, onPressed)],
            );
}

Widget _buildButton(
  String text,
  Color color,
  Function onPressed,
) {
  return Expanded(
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
  );
}
