import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/providers/user_provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  Future<void> logOutUser() async {
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
    final UserProvider userProvider = Provider.of<UserProvider>(context);
        Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Dear ' + (userProvider.getUser.firstName ?? "user") + ",",
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
                        logOutUser();
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
            accountName: const Text(''),
            accountEmail: Text(userProvider.getUser.email),
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
          (userProvider.getUser.role == 2 || userProvider.getUser.role == 3)?(
          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.indigo,),
            title: const Text('My garages'),
              onTap: () {

    }
          )
          ):(const Divider()),
          ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
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
