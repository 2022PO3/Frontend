import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({Key? key, required this.device}) : super(key: key);

  final Device device;
  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showDeviceDeletionPopUp(widget.device),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    widget.device.id.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const VerticalDivider(
                    width: 15,
                    thickness: 1,
                    color: Colors.black,
                    indent: 5,
                    endIndent: 5,
                  ),
                  const Icon(
                    Icons.phone_android_outlined,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.device.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                          width: 0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.device.confirmed
                                ? 'Confirmed'
                                : 'Not confirmed',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: widget.device.confirmed
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  void showDeviceDeletionPopUp(Device device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this device?'),
          content: const Text(
            'Are you sure that you want to delete this device? This will remove the two factor authorization from your account.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                context.pop();
                setState(() {});
                try {
                  await removeDevice(device);
                } on BackendException catch (e) {
                  print(e);
                  showFailureDialog(e.toString());
                  return;
                }
                showSuccessDialog();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
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
          title: const Text(
            'Server exception',
          ),
          content: Text(
            'We\'re sorry, but the server returned an error: $error.',
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

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Success',
          ),
          content: const Text(
            'Your device is successfully deleted and two factor authentication is disabled.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Used to refresh the page.
                setState(() {});
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

  Future<bool> removeDevice(Device device) async {
    final response = await NetworkService.sendRequest(
      requestType: RequestType.delete,
      apiSlug: StaticValues.twoFactorDevicesSlug,
      useAuthToken: true,
      pk: device.id,
    );

    return NetworkHelper.validateResponse(response);
  }
}
