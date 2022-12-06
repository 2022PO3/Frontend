import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

enum ButtonState { init, loading, done, error }

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  static const route = '/two-factor';

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
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
          child: Text('Two factor authentication'),
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
                  'Authentication code',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: const [(Colors.indigoAccent), (Colors.indigo)],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _twoFactorFormKey,
                  child: TextFormField(
                    controller: twoFactorCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      prefixIcon: Icon(
                        Icons.phone_android_sharp,
                        color: Colors.indigoAccent,
                      ),
                      hintText: 'xxxxxx',
                      counterText: '',
                      hintStyle: TextStyle(color: Colors.black38),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.indigoAccent,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1,
                        ),
                      ),
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
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: isStretched
                    ? buildButton()
                    : buildSmallButton(isDone, isError),
              ),
              const SizedBox(
                height: 15,
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
              await sendAuthenticationCode();
              setState(() => state = ButtonState.done);
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) Navigator.popAndPushNamed(context, '/home');
            } on BackendException catch (e) {
              setState(() => state = ButtonState.error);
              await Future.delayed(const Duration(seconds: 1));
              setState(() => state = ButtonState.init);
            }
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
        child: isDone || isError
            ? Icon(
                isError ? Icons.close : Icons.done,
                size: 50,
                color: Colors.white,
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Future<bool> sendAuthenticationCode() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug:
          '${StaticValues.sendAuthenticationCodeSlug}/${twoFactorCodeController.text.toString()}',
      useAuthToken: true,
    );

    return NetworkHelper.validateResponse(response);
  }
}
