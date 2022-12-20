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
  final _changeServerURLFormKey = GlobalKey<FormState>();
  final _localServerURLTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Login settings'),
      body: RefreshIndicator(
        onRefresh: () async {
          await updateUserInfo(context);
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
                  onTap: openChangeLocalURLDialog,
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

  void openChangeLocalURLDialog() {
    return showFrontendDialog2(
      context,
      'Change local server url',
      [buildLocalURLEnterWidget()],
      handleChangeLocalServerURL,
      leftButtonText: 'Confirm',
    );
  }

  void handleChangeLocalServerURL() {
    () => setLocalServerURL(context, _localServerURLTextController.text);
    context.pop();
  }

  Widget buildLocalURLEnterWidget() {
    return Form(
      key: _changeServerURLFormKey,
      child: TextFormField(
        controller: _localServerURLTextController,
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
