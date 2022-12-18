// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/utils/constants.dart';

Widget buildPressableCard({
  required List<Widget> children,
  Function()? onTap,
  Function()? onLongPress,
  bool expanded = false,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    child: buildCard(
      children: children,
      expanded: expanded,
      crossAxisAlignment: crossAxisAlignment,
    ),
  );
}

Widget buildCard({
  required List<Widget> children,
  bool expanded = false,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return expanded
      ? Row(
          children: [
            Expanded(child: _buildCard(children: children)),
          ],
        )
      : _buildCard(children: children);
}

Widget _buildCard({
  required List<Widget> children,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Card(
    shape: Constants.cardBorder,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [...children],
      ),
    ),
  );
}
