import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/device_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';

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
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: Constants.cardBorder,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_android_outlined,
                        size: 40,
                      ),
                      const VerticalDivider(
                        width: 15,
                        thickness: 1,
                        color: Colors.black,
                        indent: 5,
                        endIndent: 5,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeviceDeletionPopUp(Device device) {
    return showFrontendDialog2(
        context,
        'Delete this device?',
        [
          const Text(
            'Are you sure that you want to delete this device? This will remove the two factor authorization from your account.',
          ),
        ],
        () => handleDeviceDelete(device),
        leftButtonText: 'Confirm');
  }

  void handleDeviceDelete(Device device) async {
    context.pop();
    try {
      await removeDevice(device);
    } on BackendException catch (e) {
      print(e);
      showFailureDialog(context, e);
      return;
    }
    if (mounted) {
      showSuccessDialog(
        context,
        'Success',
        'Your device is successfully deleted and two factor authentication is disabled.',
      );
    }
    setState(() {});
  }
}
