import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Dear [user],",
            style: TextStyle(
              color: Colors.indigoAccent
            ),
          ),
          content: Text("Are you sure you want to sign out?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context,ModalRoute.withName('/home'));
                    },
                    child: Text(
                        "Cancel",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15
                      ),
                    )
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context,ModalRoute.withName('/login_page'));
                    },
                    child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.indigo,
                          fontSize: 15
                        ),
                    ),
                ),
              ],
            )
          ],

        )
    );
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
                  Icons.account_circle,
                  color: Colors.indigo
              ),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context,'/profile');
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.query_stats,
                color: Colors.indigo,
              ),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pushNamed(context, '/statistics');
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.settings,
                  color: Colors.indigo
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.help,
                  color: Colors.indigo
              ),
              title: Text('Help'),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(
                  Icons.logout,
                  color: Colors.indigo
              ),
              title: Text('Sign Out'),
              onTap: () {
                openDialog();
              }
          ),
          Divider(),
        ],
      ),
    );
  }
}
