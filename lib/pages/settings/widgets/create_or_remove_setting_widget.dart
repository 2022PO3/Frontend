import 'package:flutter/material.dart';

import '../../../utils/request_button.dart';

class CreateOrRemoveSettingWidget extends StatelessWidget {
  const CreateOrRemoveSettingWidget({
    super.key,
    required this.exists,
    required this.settingName,
    required this.onCreate,
    required this.onRemove,
  });

  final String settingName;
  final bool exists;
  final Future<void> Function() onCreate;
  final Future<void> Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  settingName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  width: exists ? 100 : 75,
                  child: RequestButton(
                    makeRequest: exists ? onRemove : onCreate,
                    text: exists ? 'Remove' : 'Add',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
