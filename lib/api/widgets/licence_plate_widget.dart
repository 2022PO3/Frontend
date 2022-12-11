import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/utils/dialogs.dart';

import '../network/network_exception.dart';

class ReservationLicencePlateWidget extends StatelessWidget {
  const ReservationLicencePlateWidget({
    Key? key,
    required this.licencePlate,
    required this.garage,
  }) : super(key: key);

  final LicencePlate licencePlate;
  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.directions_car_rounded,
                size: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                licencePlate.formatLicencePlate(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        context.go(
          '/home/reserve',
          extra: GarageAndLicencePlate(
            garage: garage,
            licencePlate: licencePlate,
          ),
        );
      },
    );
  }
}

class AddLicencePlateWidget extends StatefulWidget {
  const AddLicencePlateWidget({Key? key, required this.licencePlate})
      : super(key: key);

  final LicencePlate licencePlate;
  @override
  State<AddLicencePlateWidget> createState() => _AddLicencePlateWidgetState();
}

class _AddLicencePlateWidgetState extends State<AddLicencePlateWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.directions_car_rounded,
                size: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.licencePlate.formatLicencePlate(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      onLongPress: () {
        showLicencePlateDeletionPopUp(widget.licencePlate);
      },
    );
  }

  void showLicencePlateDeletionPopUp(LicencePlate licencePlate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this licence plate?'),
          content: const Text(
            'Are you sure that you want to delete this licence plate? This will remove all reservations made with this licence plate.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                context.pop();
                try {
                  await deleteLicencePlate(licencePlate);
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
}