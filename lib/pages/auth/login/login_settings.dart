// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:

import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/settings/widgets/toggle_setting_widget.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/server_url.dart';
import 'package:po_frontend/utils/settings_card.dart';
import 'package:po_frontend/utils/user_data.dart';

class LoginSettings extends StatefulWidget {
  const LoginSettings({super.key});

  @override
  State<LoginSettings> createState() => _LoginSettingsState();
}

class _LoginSettingsState extends State<LoginSettings> {
  final _changeLocalServerURLFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _localServerURLTextController = TextEditingController(
      text: getLocalServerURL(context),
    );
    return Scaffold(
      appBar: appBar(title: 'Login settings'),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Builder(
          builder: (context) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics().applyTo(
                const BouncingScrollPhysics(),
              ),
              children: [
                ToggleSettingWidget(
                  settingName: 'Debug',
                  currentValue: getDebug(context),
                  onToggle: (val) {
                    if (val) {
                      flipDebug(context);
                      setState(() {});
                    } else {
                      flipDebug(context);
                      setState(() {});
                    }
                  },
                ),
                InkWell(
                  onTap: () => openChangeLocalURLDialog(
                    refreshFunction: () => setState(() {}),
                    controller: _localServerURLTextController,
                  ),
                  child: buildSettingsCard(
                    context,
                    'Local server url',
                    getLocalServerURL(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void openChangeLocalURLDialog({
    required void Function() refreshFunction,
    required TextEditingController controller,
  }) {
    return showFrontendDialog2(
      context,
      'Change local server url',
      [buildLocalURLEnterWidget(controller)],
      () => handleChangeLocalServerURL(
        refreshFunction: refreshFunction,
        controller: controller,
      ),
      leftButtonText: 'Confirm',
    );
  }

  void handleChangeLocalServerURL({
    required void Function() refreshFunction,
    required TextEditingController controller,
  }) {
    if (_changeLocalServerURLFormKey.currentState!.validate()) {
      print(controller.text);
      setLocalServerURL(context, controller.text);
    }
    context.pop();
    refreshFunction();
  }

  Widget buildLocalURLEnterWidget(TextEditingController controller) {
    return Form(
      key: _changeLocalServerURLFormKey,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(14),
          prefixIcon: Icon(
            Icons.computer_rounded,
            color: Colors.indigoAccent,
          ),
          hintText: 'Local server URL...',
          hintStyle: TextStyle(color: Colors.black38),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a server URL.';
          } else if (value[value.length - 1] != '/') {
            return 'End with a \'/\'';
          }
          return null;
        },
      ),
    );
  }
}
