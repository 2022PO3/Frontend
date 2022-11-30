import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import 'package:flutter/material.dart';
import 'package:po_frontend/utils/error_dialog.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../utils/loading_page.dart';

enum ButtonState { init, loading, done, error }

class AddTwoFactorDevicePage extends StatefulWidget {
  const AddTwoFactorDevicePage({super.key});

  static const route = '/add-two-factor-device';

  @override
  State<AddTwoFactorDevicePage> createState() => _AddTwoFactorDevicePageState();
}

class _AddTwoFactorDevicePageState extends State<AddTwoFactorDevicePage> {
  final _addNameFormKey = GlobalKey<FormState>();
  final addNameController = TextEditingController();

  ButtonState state = ButtonState.init;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingPage()
        : Scaffold(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
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
                            'Add two factor device',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pushNamed(
                                context, '/add-two-factor-device');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showEnterNameDialog(context),
            ),
          );
  }

  void _showEnterNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter the name of your device'),
          content: Form(
            key: _addNameFormKey,
            child: TextFormField(
              controller: addNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(14),
                prefixIcon: Icon(
                  Icons.phone_android_sharp,
                  color: Colors.indigoAccent,
                ),
                hintText: 'Device name...',
                hintStyle: TextStyle(color: Colors.black38),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an device name.';
                } else if (!RegExp(r'^[a-z]+$').hasMatch(value)) {
                  return 'The device name may only contains letters.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                try {
                  String secret =
                      await addTwoFactorDevice(addNameController.text);
                  setState(() {
                    isLoading = false;
                  });
                  if (mounted) _showSecretDialog(context, secret);
                } on BackendException catch (e) {
                  print(e);
                  setState(() {
                    isLoading = false;
                  });
                  FailureDialog.showFailureDialog(context, e.toString());
                }
              },
              child: const Text(
                'Add device',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSecretDialog(BuildContext context, String secret) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your secret key'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                  'Below you\'ll find your secret key. Open Google Authenticator and click the add icon. Then you click on \'Enter key\'. Copy and paste the key below and you\'re done! Make sure to do it now as you\'ll not be able to see this text another time.'),
              SelectableText(secret),
              const Text(
                  'The device will become confirmed the first time you log in again.'),
            ],
          ),
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

  Future<String> addTwoFactorDevice(String name) async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        apiSlug: StaticValues.addTwoFactorDeviceSlug,
        useAuthToken: true,
        body: {'name': addNameController.text});

    return await NetworkHelper.filterResponse(
      callBack: extractSecret,
      response: response,
    );
  }

  String extractSecret(Map<String, dynamic> json) {
    String otpAuthUrl = json['otpauth'];
    Uri otpAuthUri = Uri.parse(otpAuthUrl);
    Map<String, String> queryParams = otpAuthUri.queryParameters;
    String? secret = queryParams['secret'];
    if (secret == null) {
      throw BackendException(['Secret is not part of the oauth URL.']);
    }
    return secret;
  }

  Future<bool> sendAuthenticationCode() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug:
          '${StaticValues.sendAuthenticationCodeSlug}/${addNameController.text.toString()}',
      useAuthToken: true,
    );

    return NetworkHelper.validateResponse(response);
  }
}
