import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import 'package:flutter/material.dart';
import 'package:po_frontend/api/widgets/device_widget.dart';
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
                child: Text('Two factor devices'),
              ),
            ),
            body: FutureBuilder(
              future: getDevices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final List<Device> devices = snapshot.data as List<Device>;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return DeviceWidget(device: devices[index]);
                    },
                    itemCount: devices.length,
                  );
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showEnterNameDialog(),
            ),
          );
  }

  void _showEnterNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
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
                } else if (!RegExp(r'^[A-z\s]+$').hasMatch(value)) {
                  return 'Only use letters...';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_addNameFormKey.currentState!.validate()) {
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
                    if (mounted) _showSecretDialog(secret);
                  } on BackendException catch (e) {
                    print(e);
                    setState(() {
                      isLoading = false;
                    });
                    showFailureDialog(e.toString());
                  }
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

  void _showSecretDialog(String secret) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Your secret key'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 230),
            child: Column(
              children: [
                const Text(
                  'Below you\'ll find your secret key. Open Google Authenticator and click the add icon. Then you click on \'Enter key\'. Copy and paste the key below and you\'re done! Make sure to do it now as you\'ll not be able to see this text another time.',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectableText(secret),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'The device will become confirmed the first time you log in again.'),
              ],
            ),
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
    String otpAuthUrl = json['oauthUrl'];
    Uri otpAuthUri = Uri.parse(otpAuthUrl);
    Map<String, String> queryParams = otpAuthUri.queryParameters;
    String? secret = queryParams['secret'];
    if (secret == null) {
      throw BackendException(['Secret is not part of the oauth URL.']);
    }
    return secret;
  }

  Future<List<Device>> getDevices() async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug: StaticValues.getTwoFactorDevicesSlug,
      useAuthToken: true,
    );

    return await NetworkHelper.filterResponse(
      callBack: Device.listFromJSON,
      response: response,
    );
  }
}
