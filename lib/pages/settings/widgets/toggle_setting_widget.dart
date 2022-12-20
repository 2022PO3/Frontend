// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_switch/flutter_switch.dart';

// Project imports:
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/utils/constants.dart';

class ToggleSettingWidget extends StatelessWidget {
  const ToggleSettingWidget({
    super.key,
    required this.currentValue,
    required this.onToggle,
    required this.settingName,
  });

  final String settingName;
  final bool currentValue;
  final Function(bool val) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Constants.cardBorder,
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
                FlutterSwitch(
                  height: 30,
                  width: 60,
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  toggleSize: 15,
                  value: currentValue,
                  borderRadius: 30.0,
                  padding: 8.0,
                  onToggle: onToggle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
