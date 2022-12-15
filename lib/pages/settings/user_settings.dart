import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/pages/payment_widgets/pay_button.dart';
import 'package:po_frontend/pages/settings/add_automatic_payment_page.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/settings_card.dart';
import 'package:po_frontend/utils/user_data.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
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
        child: Builder(builder: (context) {
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
                '/home/settings/two-factor',
                'Two factor devices',
                'View and edit your registered two factor devices.',
              ),
              CreateOrRemoveSettingWidget(
                settingName: 'Automatic Payment',
                exists: hasAutomaticPayment,
                onCreate: () async {
                  context.go(AddAutomaticPaymentPage.route);
                },
                onRemove: () async {
                  await removeAutomaticPayment();
                  await updateUserInfo(context);
                },
              )
            ],
          );
        }),
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
