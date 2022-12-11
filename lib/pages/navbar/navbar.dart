import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/user_data.dart';

import '../../api/models/garage_model.dart';
import '../../api/models/user_model.dart';
import '../../utils/error_widget.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
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

  @override
  Widget build(BuildContext context) {
    final User user = getUser(context);

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
          if (user.isOwner) const Divider(),
          if (user.isOwner) GarageSettingsTile(),
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

class GarageSettingsTile extends StatelessWidget {
  const GarageSettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent), // Remove dividers the expansiontile adds
      child: ExpansionTile(
        leading: Icon(Icons.settings, color: primaryColor),
        title: const Text('My Garages'),
        children: const <Widget>[_OwnedGaragesList(), _NewGarageButton()],
      ),
    );
  }
}

class _OwnedGaragesList extends StatefulWidget {
  const _OwnedGaragesList({Key? key}) : super(key: key);

  @override
  State<_OwnedGaragesList> createState() => _OwnedGaragesListState();
}

class _OwnedGaragesListState extends State<_OwnedGaragesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Garage>>(
      future: getOwnedGarages(getUser(context)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Garage> garages = snapshot.data as List<Garage>;

          return Column(
            children: garages.map((e) => GarageListTile(garage: e)).toList(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SnapshotErrorWidget(
              snapshot: snapshot,
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class GarageListTile extends StatelessWidget {
  const GarageListTile({Key? key, required this.garage}) : super(key: key);

  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(garage.name),
      leading: const Icon(Icons.car_rental_rounded),
      onTap: context.go(''),
    );
  }
}

class _NewGarageButton extends StatelessWidget {
  const _NewGarageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const StadiumBorder())),
        onPressed: null,
        icon: const Icon(Icons.add),
        label: const Text('Add new Garage'));
  }
}
