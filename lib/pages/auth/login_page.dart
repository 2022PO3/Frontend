import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/auth_requests.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/auth/register.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.email,
    required this.password,
  });

  final String? email;
  final String? password;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  String userMail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    if (automaticLogin(widget.email, widget.password)) {
      String email = widget.email as String;
      String password = widget.password as String;
      return FutureBuilder(
        future: login(
          context,
          email,
          password,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            context.go('/home');
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: appBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: appBar(title: 'Parking Boys'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Hello Again!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              buildInputField(_emailTextController, 'Email'),
              const SizedBox(
                height: 10,
              ),
              PasswordInput(
                controller: _passwordTextController,
                label: 'Password',
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(
                          Constants.borderRadius,
                        ),
                      ),
                      child: TextButton(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            userMail = _emailTextController.text;
                            userPassword = _passwordTextController.text;
                          });
                          try {
                            User user = await login(
                              context,
                              userMail,
                              userPassword,
                            );
                            if (mounted) {
                              context.go(user.twoFactor
                                  ? '/login/two-factor'
                                  : '/home');
                            }
                          } on BackendException catch (e) {
                            print(e);
                            showFailureDialog(context, e);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(
                    width: 2,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/login/register');
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFailedLoginDialog(BuildContext context, BackendException error) {
    return showFrontendDialog1(
      context,
      error.toString().contains('credentials')
          ? 'Invalid credentials entered'
          : error.toString(),
      [
        Text(
          error.toString().contains('credentials')
              ? 'Either  your password or your email address is wrong. Please try again.'
              : error.toString(),
        ),
      ],
    );
  }

  bool automaticLogin(String? email, String? password) {
    return email != null && password != null;
  }
}
