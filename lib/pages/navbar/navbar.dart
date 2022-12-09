import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/user_data.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Dear ${getUserFirstName(context)},',
              style: const TextStyle(color: Colors.indigoAccent),
            ),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      logOutUser(context);
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
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
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.event,
                color: Colors.indigo,
              ),
              title: const Text('My Reservations'),
              onTap: () {
                context.push('/home/reservations');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.indigo),
              title: const Text('Profile'),
              onTap: () {
                context.push('/home/profile');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.query_stats,
                color: Colors.indigo,
              ),
              title: const Text('Statistics'),
              onTap: () {
                context.push('/home/statistics');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () {
                context.go('/home/settings');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.help, color: Colors.indigo),
              title: const Text('Help'),
              onTap: () {
                context.push('/home/help');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.indigo),
              title: const Text('Sign Out'),
              onTap: () {
                openDialog();
              }),
          const Divider(),
        ],
      ),
    );
  }
}
