// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:po_frontend/api/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: 0,
    email: '',
    role: 0,
    firstName: null,
    lastName: null,
    favGarageId: null,
    location: null,
    hasAutomaticPayment: false,
    twoFactor: false,
    twoFactorValidated: null,
    strikes: 0,
  );

  User get getUser => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
