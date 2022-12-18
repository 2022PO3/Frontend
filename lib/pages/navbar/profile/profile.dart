// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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
      appBar: appBar(title: 'Profile'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSettingsCard(
                context,
                'User information',
                'View and edit your personal information.',
                path: '/home/profile/user-info',
              ),
              buildSettingsCard(
                context,
                'Licence plates',
                'View, edit and add licence plates to your account.',
                path: '/home/profile/licence-plates',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
