// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/requests/device_requests.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/auth/auth_service.dart';
import 'package:po_frontend/pages/settings/user_settings/add_automatic_payment_page.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/request_button.dart';
import 'package:po_frontend/utils/settings_card.dart';
import 'package:po_frontend/utils/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _changeServerURLFormKey = GlobalKey<FormState>();
  final _serverURLTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool userTwoFactor = getUserTwoFactor(context, listen: true);
    final bool hasAutomaticPayment = getUserHasAutomaticPayment(
      context,
      listen: true,
    );
    return Scaffold(
      appBar: appBar(title: 'Settings'),
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
                  settingName: 'Two Factor enabled',
                  currentValue: userTwoFactor,
                  onToggle: (val) {
                    if (!userTwoFactor && val) {
                      _showRedirectDialog();
                    } else {
                      _showConfirmationDialog();
                    }
                  },
                ),
                buildSettingsCard(
                  context,
                  'Two factor devices',
                  'View and edit your registered two factor devices.',
                  path: '/home/settings/two-factor',
                ),
                CreateOrRemoveSettingWidget(
                  settingName: 'Automatic Payment',
                  exists: hasAutomaticPayment,
                  onCreate: () async {
                    context.go(AddAutomaticPaymentPage.route);
                  },
                  onRemove: () async {
                    await deleteAutomaticPayment();
                    await updateUserInfo(context);
                  },
                ),
                FutureBuilder(
                  future: getServerURL(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return buildSettingsCard(
                          context, 'Server URL', snapshot.data ?? 'Not set',
                          onTap: openChangeServerURLDialog);
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(snapshot.error.toString()),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showRedirectDialog() {
    return showFrontendDialog2(
      context,
      'Enable two factor authentication',
      [
        const Text(
          'In order to activate the two factor authentication you have to add a device. Press OK to go to the device adding page.',
        )
      ],
      () => {context.pop(), context.go('/home/settings/two-factor')},
    );
  }

  void _showConfirmationDialog() {
    return showFrontendDialog2(
      context,
      'Disable two factor authentication',
      [const Text('Are you sure to disable two factor authentication?')],
      () => {
        disable2FA(),
        showSuccessDialog(
          context,
          'Two factor disabled',
          'Two factor authentication is disabled for your account. You can turn it back on at any time you like.',
        )
      },
      leftButtonText: 'No',
      rightButtonText: 'Yes',
    );
  }

  void openChangeServerURLDialog() {
    return showFrontendDialog2(
      context,
      'Change server url',
      [buildServerURLEnterWidget()],
      () => changeServerURL(_serverURLTextController.text),
      leftButtonText: 'Confirm',
    );
  }

  Widget buildServerURLEnterWidget() {
    return Form(
      key: _changeServerURLFormKey,
      child: TextFormField(
        controller: _serverURLTextController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(14),
          prefixIcon: Icon(
            Icons.computer_rounded,
            color: Colors.indigoAccent,
          ),
          hintText: 'Server URL...',
          hintStyle: TextStyle(color: Colors.black38),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a server URL.';
          } else if (value[value.length] != '/') {
            return 'End with a \'/\'';
          }
          return null;
        },
      ),
    );
  }

  Future<String> getServerURL() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('serverUrl') ?? 'Not set';
  }

  void changeServerURL(String serverURL) async {
    if (_changeServerURLFormKey.currentState!.validate()) {
      final pref = await SharedPreferences.getInstance();
      final String serverURL = _serverURLTextController.text;
      AuthService.setServerURL(pref, serverURL);
      if (mounted) context.go('/login');
    }
  }
}

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
                SizedBox(
                  width: exists ? 100 : 60,
                  height: 30,
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