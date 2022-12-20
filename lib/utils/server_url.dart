import 'package:flutter/cupertino.dart';
import 'package:po_frontend/providers/local_server_url_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getLocalServerURL(BuildContext context, {bool listen = false}) {
  final LocalServerURLProvider localServerURLProvider =
      Provider.of<LocalServerURLProvider>(
    context,
    listen: listen,
  );
  return localServerURLProvider.localServerURL;
}

void setLocalServerURL(
  BuildContext context,
  String localServerURL, {
  bool listen = false,
}) async {
  final LocalServerURLProvider localServerURLProvider =
      Provider.of<LocalServerURLProvider>(
    context,
    listen: listen,
  );
  final pref = await SharedPreferences.getInstance();
  pref.setString('localServerURL', localServerURL);

  return localServerURLProvider.setLocalServerURL(localServerURL);
}

void flipDebug(BuildContext context, {bool listen = false}) async {
  final LocalServerURLProvider localServerURLProvider =
      Provider.of<LocalServerURLProvider>(
    context,
    listen: listen,
  );
  localServerURLProvider.setDebug();
  final pref = await SharedPreferences.getInstance();
  if (localServerURLProvider.debug) {
    pref.setBool('override', true);
    pref.setString('localServerURL', getLocalServerURL(context));
  } else {
    pref.setBool('false', true);
  }
}

bool getDebug(BuildContext context, {bool listen = false}) {
  final LocalServerURLProvider localServerURLProvider =
      Provider.of<LocalServerURLProvider>(
    context,
    listen: listen,
  );
  return localServerURLProvider.debug;
}

String getServerURL(BuildContext context, {bool listen = false}) {
  final LocalServerURLProvider localServerURLProvider =
      Provider.of<LocalServerURLProvider>(
    context,
    listen: listen,
  );
  bool debug = localServerURLProvider.debug;
  if (debug) {
    return getLocalServerURL(context);
  } else {
    return 'https://po3backend.ddns.net/';
  }
}
