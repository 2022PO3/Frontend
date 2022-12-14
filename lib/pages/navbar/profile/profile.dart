import 'package:flutter/material.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/settings_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Settings'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSettingsCard(
                context,
                '/home/profile/user-info',
                'User information',
                'View and edit your personal information.',
              ),
              buildSettingsCard(
                context,
                '/home/profile/licence-plates',
                'Licence plates',
                'View, edit and add licence plates to your account.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
