import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/device_model.dart';

class DeviceWidget extends StatelessWidget {
  const DeviceWidget({Key? key, required this.device}) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                device.id.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Icon(
                Icons.phone_android_sharp,
                size: 40,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Device name: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    device.confirmed ? 'Confirmed' : 'Not confirmed',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: device.confirmed ? Colors.green : Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
