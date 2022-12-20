// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/device_requests.dart';
import 'package:po_frontend/api/widgets/device_widget.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../utils/loading_page.dart';

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
            appBar: appBar(
              title: 'Two factor devices',
              refreshButton: true,
              refreshFunction: () => setState(() => {}),
            ),
            body: FutureBuilder(
              future: getDevices(context),
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
    return showFrontendDialog1(
      context,
      'Enter the name of your device',
      [buildEnterNameForm()],
      buttonText: 'Add device',
      buttonFunction: () => handleAddTwoFactorDevice(),
    );
  }

  Form buildEnterNameForm() {
    return Form(
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
    );
  }

  void handleAddTwoFactorDevice() async {
    if (_addNameFormKey.currentState!.validate()) {
      context.pop();
      setState(() {
        isLoading = true;
      });
      try {
        String secret = await postDevice(context, addNameController.text);
        setState(() {
          isLoading = false;
        });
        if (mounted) _showSecretDialog(secret);
      } on BackendException catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        showFailureDialog(context, e);
      }
    }
  }

  void _showSecretDialog(String secret) {
    return showFrontendDialog1(
      context,
      'Your secret key',
      [buildSecretDialogContent(secret)],
      buttonFunction: () async => {
        context.pop(),
        await updateUserInfo(context),
      },
    );
  }

  Column buildSecretDialogContent(String secret) {
    return Column(
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
    );
  }
}
