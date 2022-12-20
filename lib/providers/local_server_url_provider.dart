// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:po_frontend/api/network/static_values.dart';

class LocalServerURLProvider with ChangeNotifier {
  String _localServerURL = StaticValues.localURL;
  bool _debug = StaticValues.debug;

  String get localServerURL => _localServerURL;
  bool get debug => _debug;

  void setLocalServerURL(String localServerURL) {
    _localServerURL = localServerURL;
    notifyListeners();
  }

  void setDebug() {
    _debug = !_debug;
    notifyListeners();
  }
}
