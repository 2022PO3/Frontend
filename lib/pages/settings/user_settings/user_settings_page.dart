import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/payment_widgets/pay_button.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/settings_card.dart';
import 'package:po_frontend/utils/user_data.dart';

import '../widgets/create_or_remove_setting_widget.dart';
import '../widgets/toggle_setting_widget.dart';
import 'add_automatic_payment_page.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final bool userTwoFactor = getUserTwoFactor(context, listen: true);
    final bool automaticPayment =
        getUserAutomaticPayment(context, listen: true);
    return Scaffold(
      appBar: appBar('Settings', false, null),
      body: RefreshIndicator(
        onRefresh: () async {
          await updateUserInfo(context);
        },
        child: Builder(builder: (context) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics()
                .applyTo(const BouncingScrollPhysics()),
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
                exists: automaticPayment,
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enable two factor authentication'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 230),
            child: Column(
              children: const [
                Text(
                  'In order to activate the two factor authentication you have to add a device. Press OK to go to the device adding page.',
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.go('/home/settings/two-factor');
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Disable two factor authentication'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 230),
            child: Column(
              children: const [
                Text(
                  'Are you sure to disable two factor authentication?',
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                try {
                  disable2FA();
                  showSuccessDialog(
                    context,
                    'Two factor disabled',
                    'Two factor authentication is disabled for your account. You can turn it back on at any time you like.',
                  );
                } on BackendException catch (e) {
                  print(e);
                }
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
