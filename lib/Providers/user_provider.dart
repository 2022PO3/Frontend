import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  String _email = '';
  String _token = '';

  String get email => _email;
  String get token => _token;

  void Change_email(String Mail) {
    _email = Mail;
  }
  void Change_token(String Token) {
    _token = Token;
  }
}