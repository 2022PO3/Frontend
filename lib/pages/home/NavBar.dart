import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("Default"),
              accountEmail: Text("Default@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                // Hier komt de afbeelding te staan
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.amber,
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
            }
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.query_stats,
                color: Colors.indigo,
              ),
              title: Text('Statistics'),
              onTap: () => print('Fav')
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.account_circle,
                  color: Colors.indigo
              ),
              title: Text('Profile'),
              onTap: () => print('Fav')
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.settings,
                  color: Colors.indigo
              ),
              title: Text('Settings'),
              onTap: () => print('Fav')
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.logout,
                  color: Colors.indigo
              ),
              title: Text('Sign Out'),
              onTap: () => print('Fav')
          ),
          Divider(),
        ],
      ),
    );
  }
}
