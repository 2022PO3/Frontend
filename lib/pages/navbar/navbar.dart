import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/requests/auth_requests.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../api/models/garage_model.dart';
import '../../utils/error_widget.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final User user = getProviderUser(context);
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
          if (user.isGarageOwner) const GarageSettingsTile(),
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
      () => logOut(context),
      leftButtonText: 'Yes',
      rightButtonText: 'No',
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

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: Icon(Icons.garage_rounded, color: primaryColor),
            title: const Text('My Garages'),
            children: const <Widget>[_OwnedGaragesList(), _NewGarageButton()],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _OwnedGaragesList extends StatelessWidget {
  const _OwnedGaragesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Garage>>(
      future: getOwnedGarages(getProviderUser(context)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Garage> garages = snapshot.data as List<Garage>;

          return Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Column(
              children: garages.map((e) => GarageListTile(garage: e)).toList(),
            ),
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
      onTap: () => context.go('/home/settings/garage/${garage.id}'),
      trailing: const Icon(Icons.keyboard_arrow_right),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => context.go('/home/settings/add-garage'),
      icon: const Icon(Icons.add),
      label: const Text('Add new Garage'),
    );
  }
}
