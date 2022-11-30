import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/utils/error_dialog.dart';

enum ButtonState { init, loading, done, error }

class UserActivationPage extends StatefulWidget {
  const UserActivationPage({
    super.key,
    required this.uidB64,
    required this.token,
  });

  static const routeName = '/user-activation';

  final String uidB64;
  final String token;

  @override
  State<UserActivationPage> createState() => _UserActivationPageState();
}

class _UserActivationPageState extends State<UserActivationPage> {
  bool isAnimating = true;
  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    final isDone = state == ButtonState.done;
    final isError = state == ButtonState.error;
    final isStretched = isAnimating || state == ButtonState.init;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GradientText(
                  'Hello!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  colors: const [(Colors.indigoAccent), (Colors.indigo)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GradientText(
                  'Welcome to Parking Boys.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  colors: const [(Colors.indigoAccent), (Colors.indigo)],
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
                child: isStretched
                    ? buildButton()
                    : buildSmallButton(isDone, isError),
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
          setState(() => state = ButtonState.loading);
          try {
            await sendActivationRequest();
            setState(() => state = ButtonState.done);
            if (mounted) {
              _showSuccessDialog(context);
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) Navigator.popAndPushNamed(context, '/login_page');
            }
          } on BackendException catch (e) {
            setState(() => state = ButtonState.error);
            FailureDialog.showFailureDialog(context, e.toString());
          }
        },
      ),
    );
  }

  Widget buildSmallButton(bool isDone, bool isError) {
    List<Color> color = isDone
        ? [(Colors.green), (Colors.green)]
        : [(Colors.indigo), (Colors.indigoAccent)];

    if (isError) {
      color = [(Colors.red), (Colors.red)];
    }
    return Container(
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: color,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: isDone
              ? Icon(
                  isError ? Icons.done : Icons.close,
                  size: 52,
                  color: Colors.white,
                )
              : const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
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
