import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

class UserActivationPage extends StatefulWidget {
  const UserActivationPage({
    super.key,
    required this.uidB64,
    required this.token,
  });

  final String? uidB64;
  final String? token;

  @override
  State<UserActivationPage> createState() => _UserActivationPageState();
}

class _UserActivationPageState extends State<UserActivationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [(Colors.indigo), (Colors.indigoAccent)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Center(
          child: Text('Parking Boys'),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Welcome to Parking Boys.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Thank you for registering with us. Please click the button below to activate your account so that you can log in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: buildButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return Container(
      height: 50,
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
          minimumSize: const Size.fromHeight(35),
        ),
        child: const Text(
          'Activate your account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            await sendActivationRequest();
            if (mounted) {
              _showSuccessDialog();
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) context.go('/login');
            }
          } on BackendException catch (e) {
            showFailureDialog(e.toString());
          }
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account activated!'),
          content: const Text(
              'Your account has been successfully activated. You\'ll now be redirected to the login page where you can login.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.go('/login');
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

  void showFailureDialog(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Server exception'),
          content:
              Text('We\'re sorry, but the server returned an error: $error.'),
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

  Future<bool> sendActivationRequest() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug:
          '${StaticValues.activateUserSlug}/${widget.uidB64}/${widget.token}',
      useAuthToken: false,
    );

    return NetworkHelper.validateResponse(response);
  }
}
