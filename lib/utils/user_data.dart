// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/providers/user_provider.dart';

int getUserId(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.id;
}

User getProviderUser(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser;
}

String getUserFirstName(
  BuildContext context, {
  bool listen = false,
  String dummy = '',
}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.firstName ?? dummy;
}

String getUserLastName(
  BuildContext context, {
  bool listen = false,
  String dummy = '',
}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.lastName ?? dummy;
}

String getUserLocation(
  BuildContext context, {
  bool listen = false,
  String dummy = '',
}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  ProvinceEnum? userProvince = userProvider.getUser.location;
  return userProvince == null ? 'Not given' : userProvince.name;
}

Future<String> getUserFavGarageName(
  BuildContext context, {
  bool listen = false,
}) async {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  int? favGarageId = userProvider.getUser.favGarageId;
  if (favGarageId == null) {
    return 'Not set';
  } else {
    Garage garage = await getGarage(favGarageId);
    return garage.name;
  }
}

String getUserEmail(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.email;
}

bool getUserTwoFactor(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.twoFactor;
}

bool getUserHasAutomaticPayment(BuildContext context, {bool listen = false}) {
  final UserProvider userProvider = Provider.of<UserProvider>(
    context,
    listen: listen,
  );
  return userProvider.getUser.hasAutomaticPayment;
}

Future<void> updateUserInfo(BuildContext context) async {
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(await getUser());
}

void setUser(BuildContext context, User user) {
  final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(user);
}
