import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(''),
            accountEmail: Text(
              getUserEmail(context),
            ),
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
              image: DecorationImage(
                image: AssetImage('Afbeeldingen/Mountains.png'),
                opacity: 0.95,
                fit: BoxFit.cover,
              ),
            ),
          ),
          buildListTile(
            leadingIcon: Icons.event_rounded,
            title: 'My reservations',
            onTap: () => context.push('/home/reservations'),
          ),
          buildListTile(
            leadingIcon: Icons.account_circle_rounded,
            title: 'Profile',
            onTap: () => context.push('/home/profile'),
          ),
          buildListTile(
            leadingIcon: Icons.settings_rounded,
            title: 'Settings',
            onTap: () => context.push('/home/settings'),
          ),
          buildListTile(
            leadingIcon: Icons.logout_rounded,
            title: 'Sign out',
            onTap: () => openSignOutDialog(context),
          ),
        ],
      ),
    );
  }

  Column buildListTile({
    required IconData leadingIcon,
    required String title,
    required Function() onTap,
  }) {
    return Column(
      children: [
        ListTile(
            leading: Icon(leadingIcon, color: Colors.indigo),
            title: Text(title),
            onTap: () {
              onTap();
            }),
        const Divider(),
      ],
    );
  }

  void openSignOutDialog(BuildContext context) {
    return showFrontendDialog2(
      context,
      'Sign out',
      [const Text('Are you sure you want to sign out?')],
      () => logOutUser(context),
    );
  }
}
