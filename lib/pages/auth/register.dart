import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/auth_requests.dart';

import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import '../../api/network/network_exception.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      appBar: appBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Create a new account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildInputField(_firstNameTextController, 'First Name'),
                const SizedBox(
                  height: 13,
                ),
                buildInputField(_lastNameTextController, 'Last Name'),
                const SizedBox(
                  height: 13,
                ),
                buildInputField(_emailTextController, 'Email'),
                const SizedBox(
                  height: 13,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          icon: const Icon(
                            Icons.clear,
                          ),
                        ),
                      ),
                      controller: _passwordTextController,
                    ),
                  ),
                ),
                buildValidators(
                  'Contains a capital letter',
                  _hasCapitalLetter,
                ),
                buildValidators(
                  'Contains at least 10 characters',
                  _isPasswordEightCharacters,
                ),
                buildValidators(
                  'Contains at least 1 number',
                  _hasPasswordOneNumber,
                ),
                buildValidators(
                  'Contains a special character',
                  _hasSpecialCharacter,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (password) => onPasswordMatch(
                          _passwordTextController.text, password),
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
                          icon: const Icon(
                            Icons.clear,
                          ),
                        ),
                      ),
                      controller: _confirmPasswordTextController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: _passwordMatch
                              ? Colors.green
                              : Colors.transparent,
                          border: _passwordMatch
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(
                            Constants.borderRadius,
                          ),
                        ),
                        child: TextButton(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              userFirstName = _firstNameTextController.text;
                              if (userFirstName == '') {
                                userFirstName = null;
                              }
                              userLastName = _lastNameTextController.text;
                              if (userLastName == '') {
                                userLastName = null;
                              }
                              userMail = _emailTextController.text;
                              userPassword = _passwordTextController.text;
                              userConfirmPassword =
                                  _confirmPasswordTextController.text;
                            });
                            if (_passwordMatch &&
                                _hasSpecialCharacter &&
                                _hasCapitalLetter &&
                                _hasPasswordOneNumber &&
                                _isPasswordEightCharacters) {
                              try {
                                await register(
                                    userMail,
                                    userPassword,
                                    userConfirmPassword,
                                    userFirstName,
                                    userLastName);
                                if (mounted) {
                                  showSuccessDialog(
                                      context,
                                      'Successfully registered!',
                                      'You have successfully registered your account. You\'ll receive an email shortly on the email address that you\'ve entered, such that you can activate your account. You\'ll now be redirected to the login page.');
                                  await Future.delayed(
                                    const Duration(seconds: 4),
                                  );
                                  if (mounted) context.pop();
                                }
                              } on BackendException catch (e) {
                                print('Error occurred $e');
                                showFailureDialog(context, e);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildValidators(String text, bool validator) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: validator ? Colors.green : Colors.transparent,
                  border: validator
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildInputField(
  TextEditingController? controller,
  String hintText, {
  String? initialValue,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        Constants.borderRadius,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              controller!.clear();
            },
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ),
        controller: controller,
      ),
    ),
  );
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final Function(String password)? onChanged;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(
          Constants.borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 10,
        ),
        child: TextField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.label,
            hintStyle: const TextStyle(fontSize: 20),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          controller: widget.controller,
          onChanged: (String password) => widget.onChanged?.call(password),
        ),
      ),
    );
  }
}
