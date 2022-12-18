// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/utils/constants.dart';

Widget buildSettingsCard(
  BuildContext context,
  String path,
  String title,
  String subtitle,
) {
  return Card(
    shape: Constants.cardBorder,
    child: InkWell(
      onTap: () => context.push(path),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(), // Make widget as wide as possible
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    ),
  );
}
