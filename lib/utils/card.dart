import 'package:flutter/material.dart';
import 'package:po_frontend/utils/constants.dart';

Widget buildCard({
  required List<Widget> children,
  bool expanded = false,
}) {
  return expanded
      ? Row(
          children: [
            Expanded(child: _buildCard(children: children)),
          ],
        )
      : _buildCard(children: children);
}

Widget _buildCard({required List<Widget> children}) {
  return Card(
    shape: Constants.cardBorder,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Column(
        children: [...children],
      ),
    ),
  );
}
