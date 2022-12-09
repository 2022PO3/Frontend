import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [(Colors.indigo), (Colors.indigoAccent)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Center(
          child: Text('Settings'),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
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
                          const Text(
                            'Two factor enabled',
                            style: TextStyle(
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
                            value: user.twoFactor,
                            borderRadius: 30.0,
                            padding: 8.0,
                            onToggle: (val) {
                              if (!user.twoFactor && val) {
                                _showRedirectDialog();
                              } else {
                                _showConfirmationDialog();
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () => context.push('/home/settings/two-factor'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Two factor devices',
                              style: TextStyle(
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
                          children: const [
                            Text(
                              'View and edit your registered two factor devices.',
                              style: TextStyle(
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
              ),
            ],
          ),
        ),
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
                  _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Two factor disabled'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 230),
            child: Column(
              children: const [
                Text(
                  'Two factor authentication is disabled for your account. You can turn it back on at any time you like.',
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
