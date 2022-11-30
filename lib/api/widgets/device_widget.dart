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
            children: [
              Text(device.id.toString()),
              const Icon(
                Icons.phone_android_sharp,
                size: 30,
              ), 
              Column(
                children: [
                  Text(device.name),
                  Text(device.confirmed ? 'Confirmed' : 'Not confirmed'),
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
