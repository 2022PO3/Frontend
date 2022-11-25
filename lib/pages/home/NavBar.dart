import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  Future<void> LogoutUser() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.postLogoutUser,
      useAuthToken: true,
      //    body: body
    );
    if (response?.statusCode == 204) {
      final userInfo = await SharedPreferences.getInstance();
      userInfo.remove('authToken');
      Navigator.popUntil(context, ModalRoute.withName('/login_page'));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Dear [user],",
                style: TextStyle(color: Colors.indigoAccent),
              ),
              content: Text("Are you sure you want to sign out?"),
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
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )),
                    TextButton(
                      onPressed: () {
                        LogoutUser();
                      },
                      child: Text(
                        "Confirm",
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
            accountName: Text("Default"),
            accountEmail: Text("Default@gmail.com"),
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              image: DecorationImage(
                image: AssetImage('Afbeeldingen/Mountains.png'),
                opacity: 0.95,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.event,
                color: Colors.indigo,
              ),
              title: Text('My Reservations'),
              onTap: () {
                Navigator.pushNamed(context, '/My_Reservations');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.account_circle, color: Colors.indigo),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.query_stats,
                color: Colors.indigo,
              ),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pushNamed(context, '/statistics');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.indigo),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.help, color: Colors.indigo),
              title: Text('Help'),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout, color: Colors.indigo),
              title: Text('Sign Out'),
              onTap: () {
                openDialog();
              }),
          Divider(),
        ],
      ),
    );
  }
}
