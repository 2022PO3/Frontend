import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/pages/auth/register.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/user_model.dart';

import '../../api/network/network_exception.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.email, required this.password});

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
        future: loginUser(
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
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [(Colors.indigo), (Colors.indigoAccent)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Parking Boys'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [(Colors.indigo), (Colors.indigoAccent)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientText(
                'Hello Again!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [(Colors.indigoAccent), (Colors.indigo)],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientText(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [(Colors.indigoAccent), (Colors.indigo)],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextInput(controller: _emailTextController, label: 'Email'),
            const SizedBox(
              height: 10,
            ),
            //password textfield

            PasswordInput(
              controller: _passwordTextController,
              label: 'Password',
            ),

            const SizedBox(
              height: 20,
            ),
            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [(Colors.indigo), (Colors.indigoAccent)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(20),
                  ),
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
                      User user = await loginUser(
                        context,
                        userMail,
                        userPassword,
                      );
                      if (mounted) {
                        context
                            .go(user.twoFactor ? '/login/two-factor' : '/home');
                      }
                    } on BackendException catch (e) {
                      print(e);
                      showFailureDialog(e.toString());
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            //not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member? '),
                TextButton(
                  onPressed: () {
                    context.go('/login/register');
                  },
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showFailureDialog(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            error.contains('credentials')
                ? 'Invalid credentials entered'
                : error,
          ),
          content: Text(
            error.contains('credentials')
                ? 'Either  your password or your email address is wrong. Please try again.'
                : error,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
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

  bool automaticLogin(String? email, String? password) {
    return email != null && password != null;
  }
}
