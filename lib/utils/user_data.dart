import 'package:flutter/cupertino.dart';
import 'package:po_frontend/api/models/user_model.dart';
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
