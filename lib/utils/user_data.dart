import 'package:flutter/cupertino.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

int getUserId(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.id;
}

User getUser(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser;
}

String getUserName(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.firstName ?? '';
}

String getUserEmail(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.email;
}

Future<void> updateUserInfo(BuildContext context) async {
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(await getUserInfo());
}
