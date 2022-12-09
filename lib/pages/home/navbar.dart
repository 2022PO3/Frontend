import 'package:flutter/material.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/user_data.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/providers/user_provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Dear [user],',
                style: TextStyle(color: Colors.indigoAccent),
              ),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/home'));
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )),
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
            ));
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(children: [
              Text(userProvider.getUser.firstName ?? 'Firstname'),
              const Text(' '),
              Text(userProvider.getUser.lastName ?? 'LastName')
            ]),
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
                Navigator.pushNamed(context, '/my_Reservations');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.indigo),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.query_stats,
                color: Colors.indigo,
              ),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pushNamed(context, '/statistics');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.help, color: Colors.indigo),
              title: const Text('Help'),
              onTap: () {
                Navigator.pushNamed(context, '/help');
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
