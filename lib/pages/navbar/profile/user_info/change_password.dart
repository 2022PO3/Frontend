import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordTextController = TextEditingController();
  final newPasswordTextController = TextEditingController();
  final checkPasswordTextController = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasCapitalLetter = false;
  bool _hasSpecialCharacter = false;
  bool _passwordMatch = false;

  String newPassword = '';
  String oldPassword = '';
  String passwordConfirmation = '';

  bool _currentObscureText = true;
  bool _newObscureText = true;
  bool _confirmObscureText = true;

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
      appBar: appBar(title: 'Change your password'),
      body: Column(
        children: [
          Card(
            shape: Constants.cardBorder,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                children: [
                  const Text(
                      'Please enter your current password in the box below.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  TextField(
                    obscureText: _currentObscureText,
                    decoration: InputDecoration(
                      hintText: 'Current password',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _currentObscureText = !_currentObscureText;
                          });
                        },
                        icon: Icon(
                          _currentObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    controller: currentPasswordTextController,
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: Constants.cardBorder,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                children: [
                  const Text('What do you want to change your password to?',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  TextField(
                    onChanged: (password) => onPasswordChanged(
                        password, checkPasswordTextController.text),
                    obscureText: _newObscureText,
                    decoration: InputDecoration(
                      hintText: 'new password',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _newObscureText = !_newObscureText;
                          });
                        },
                        icon: Icon(
                          _newObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    controller: newPasswordTextController,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _hasCapitalLetter
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasCapitalLetter
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
                      const SizedBox(width: 5),
                      const Text(
                        'Contains a capital letter',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _isPasswordEightCharacters
                              ? Colors.green
                              : Colors.transparent,
                          border: _isPasswordEightCharacters
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Contains at least 10 characters',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _hasPasswordOneNumber
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasPasswordOneNumber
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
                        'Contains at least 1 number',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _hasSpecialCharacter
                              ? Colors.green
                              : Colors.transparent,
                          border: _hasSpecialCharacter
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
                        'Contains a special character',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: Constants.cardBorder,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                children: [
                  const Text(
                      'Please confirm your new password in the box below.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  TextField(
                    onChanged: (password) => onPasswordMatch(
                        newPasswordTextController.text, password),
                    obscureText: _confirmObscureText,
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmObscureText = !_confirmObscureText;
                          });
                        },
                        icon: Icon(
                          _confirmObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    controller: checkPasswordTextController,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
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
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Both passwords match',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Height(5),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          const Height(5),
          buildButton(
            'Confirm',
            Colors.indigoAccent,
            () => handlePasswordChange(),
            withCardPadding: true,
          ),
        ],
      ),
    );
  }

  void handlePasswordChange() async {
    setState(() {
      newPassword = newPasswordTextController.text;
      oldPassword = currentPasswordTextController.text;
      passwordConfirmation = checkPasswordTextController.text;
    });
    if (_passwordMatch &&
        _hasSpecialCharacter &&
        _hasCapitalLetter &&
        _hasPasswordOneNumber &&
        _isPasswordEightCharacters) {
      try {
        await putPassword(
          newPassword,
          oldPassword,
          passwordConfirmation,
        );
        if (mounted) {
          showSuccessDialog(
            context,
            'Password successfully changed!',
            'You have successfully changed your password. You\'ll now be redirected to the login page.',
          );
          await Future.delayed(
            const Duration(seconds: 2),
          );
          if (mounted) context.pop();
        }
      } on BackendException catch (e) {
        print('Error occurred $e');
        showFailureDialog(context, e);
      }
    }
  }
}
