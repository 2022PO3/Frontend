import 'package:flutter/cupertino.dart';
import 'package:po_frontend/api/models/user_model.dart';

class UserProvider with ChangeNotifier {
  late final User _user;

  User get getUser => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
