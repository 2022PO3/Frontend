// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/auth_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';

enum ButtonState { init, loading, done, error }

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  static const route = '/login/two-factor';

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final _twoFactorFormKey = GlobalKey<FormState>();
  final twoFactorCodeController = TextEditingController();

  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    final isDone = state == ButtonState.done;
    final isError = state == ButtonState.error;
    final isStretched = state == ButtonState.init;

    return Scaffold(
      appBar: appBar(
        title: 'Two Factor authentication',
        refreshButton: true,
        refreshFunction: () => setState(() => {}),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Authentication code',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: _twoFactorFormKey,
                  child: TextFormField(
                    controller: twoFactorCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(14),
                      prefixIcon: const Icon(
                        Icons.phone_android_sharp,
                        color: Colors.indigoAccent,
                      ),
                      hintText: 'xxxxxx',
                      counterText: '',
                      hintStyle: const TextStyle(color: Colors.black38),
                      enabledBorder: textFieldBorder(Colors.indigo),
                      focusedBorder: textFieldBorder(Colors.indigoAccent),
                      focusedErrorBorder: textFieldBorder(Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an authentication code.';
                      } else if (value.length < 6) {
                        return 'The authentication code has a length of 6 digits.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isStretched ? buildButton() : buildSmallButton(isDone, isError),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder textFieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          Constants.borderRadius,
        ),
      ),
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
    );
  }

  Widget buildButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.circular(
          Constants.borderRadius,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (_twoFactorFormKey.currentState!.validate()) {
                  setState(() => {state = ButtonState.loading});
                  try {
                    await sendAuthenticationCode(
                      context,
                      twoFactorCodeController.text,
                    );
                    setState(() => state = ButtonState.done);
                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) context.go('/home');
                  } on BackendException {
                    setState(() => state = ButtonState.error);
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() => state = ButtonState.init);
                  }
                }
              },
            ),
          ),
        ],
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
        child: isDone || isError
            ? Icon(
                isError ? Icons.close : Icons.done,
                size: 50,
                color: Colors.white,
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
