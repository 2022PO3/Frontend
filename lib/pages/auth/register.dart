import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import '../../api/network/network_exception.dart';

class RegisterNow extends StatefulWidget {
  const RegisterNow({Key? key}) : super(key: key);

  @override
  State<RegisterNow> createState() => _RegisterNowState();
}

class _RegisterNowState extends State<RegisterNow> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasCapitalLetter = false;
  bool _hasSpecialCharacter = false;
  bool _passwordMatch = false;

  String? userFirstName = '';
  String? userLastName = '';
  String userMail = '';
  String userPassword = '';
  String userConfirmPassword = '';

  onPasswordChanged(String password, String passwordConfirmation) {
    final numericRegex = RegExp(r'[0-9]');
    final capitalCharacterRegex = RegExp(r'[A-Z]');
    final specialCharacterRegex = RegExp(r'[@_!#$%^&*()<>?/\|}{~:;]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 10) {
        _isPasswordEightCharacters = true;
      }
      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }
      _hasCapitalLetter = false;
      if (capitalCharacterRegex.hasMatch(password)) {
        _hasCapitalLetter = true;
      }
      _hasSpecialCharacter = false;
      if (specialCharacterRegex.hasMatch(password)) {
        _hasSpecialCharacter = true;
      }
      _passwordMatch = false;
      if (password == passwordConfirmation &&
          password != '' &&
          passwordConfirmation != '') {
        _passwordMatch = true;
      }
    });
  }

  void onPasswordMatch(String password, String passwordConfirmation) {
    setState(() {
      _passwordMatch = false;
      if (password == passwordConfirmation) {
        _passwordMatch = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [(Colors.indigo), (Colors.indigoAccent)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientText(
                'Create a new account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [(Colors.indigoAccent), (Colors.indigo)],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _firstNameTextController.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _firstNameTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last Name',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _lastNameTextController.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _lastNameTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _emailTextController.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _emailTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    onChanged: (password) => onPasswordChanged(
                        password, _confirmPasswordTextController.text),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordTextController.clear();
                                _passwordMatch = false;
                                _isPasswordEightCharacters = false;
                                _hasPasswordOneNumber = false;
                                _hasCapitalLetter = false;
                                _hasSpecialCharacter = false;
                              });
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _passwordTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _hasCapitalLetter
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasCapitalLetter
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains a capital letter',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _isPasswordEightCharacters
                              ? Colors.green
                              : Colors.transparent,
                          border: _isPasswordEightCharacters
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains at least 10 characters',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _hasPasswordOneNumber
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasPasswordOneNumber
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains at least 1 number',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _hasSpecialCharacter
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasSpecialCharacter
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains a special character',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    onChanged: (password) =>
                        onPasswordMatch(_passwordTextController.text, password),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmPasswordTextController.clear();
                                _passwordMatch = false;
                              });
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _confirmPasswordTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: _passwordMatch
                              ? Colors.green
                              : Colors.transparent,
                          border: _passwordMatch
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(width: 10),
                  const Text(
                    'Both passwords match',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 65,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [(Colors.indigo), (Colors.indigoAccent)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(30),
                  ),
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      if (_firstNameTextController.text == "") {
                        userFirstName = null;
                      }
                      if (_lastNameTextController.text == "") {
                        userLastName = null;
                      }
                      userMail = _emailTextController.text;
                      userPassword = _passwordTextController.text;
                      userConfirmPassword = _confirmPasswordTextController.text;
                    });
                    if (_passwordMatch &&
                        _hasSpecialCharacter &&
                        _hasCapitalLetter &&
                        _hasPasswordOneNumber &&
                        _isPasswordEightCharacters) {
                      try {
                        await registerUser(userMail, userPassword,
                            userConfirmPassword, userFirstName, userLastName);
                        if (mounted) {
                          _showSuccessDialog(context);
                          await Future.delayed(const Duration(seconds: 4));
                          if (mounted) {
                            Navigator.popAndPushNamed(context, '/login_page');
                          }
                        }
                      } on BackendException catch (e) {
                        print('Error occurred $e');
                        _showFailureDialog(context, e.toString());
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> registerUser(
      String emailUser,
      String passwordUser,
      String confirmPasswordUser,
      String? firstNameUser,
      String? lastNameUser) async {
    Map<String, dynamic> body = {
      'email': emailUser,
      'password': passwordUser,
      'passwordConfirmation': confirmPasswordUser,
      'role': 1,
      'firstName': firstNameUser,
      'lastName': lastNameUser,
    };
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.postRegisterUser,
      body: body,
      useAuthToken: false,
    );
    return NetworkHelper.validateResponse(response);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successfully registered!'),
          content: const Text(
              'You have successfully registered your account. You\'ll receive an email shortly on the email address that you\'ve entered, such that you can activate your account. You\'ll now be redirected to the login page.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Server exception'),
          content:
              Text('We\'re sorry, but the server returned an error: $error.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
