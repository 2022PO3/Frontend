import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildSettingsCard(
  BuildContext context,
  String path,
  String title,
  String subtitle,
) {
  return Card(
    child: InkWell(
      onTap: () => context.push(path),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
