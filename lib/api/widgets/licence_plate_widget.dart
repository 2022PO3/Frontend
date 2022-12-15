import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';

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
        shape: Constants.cardBorder,
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
  const AddLicencePlateWidget({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final LicencePlate licencePlate;
  @override
  State<AddLicencePlateWidget> createState() => _AddLicencePlateWidgetState();
}

class _AddLicencePlateWidgetState extends State<AddLicencePlateWidget> {
  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.licencePlate.enabled;
    return InkWell(
      child: Card(
        shape: Constants.cardBorder,
        color: enabled ? Colors.green.shade300 : Colors.red.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.directions_car_rounded,
                    size: 50,
                  ),
                  const Width(10),
                  Text(
                    widget.licencePlate.formatLicencePlate(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                enabled ? 'Confirmed' : 'Not confirmed',
                style: TextStyle(
                  color: enabled ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => showEnableLicencePlatePopUp(widget.licencePlate),
      onLongPress: () => showLicencePlateDeletionPopUp(widget.licencePlate),
    );
  }

  void showLicencePlateDeletionPopUp(LicencePlate licencePlate) {
    showFrontendDialog2(
      context,
      'Delete this licence plate?',
      [
        const Text(
          'Are you sure that you want to delete this licence plate? This will remove all reservations made with this licence plate.',
        ),
      ],
      () => handleLicencePlateDeletion(licencePlate),
      leftButtonText: 'Yes',
      rightButtonText: 'No',
    );
  }

  void handleLicencePlateDeletion(LicencePlate licencePlate) async {
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
  }

  void showEnableLicencePlatePopUp(LicencePlate licencePlate) {
    showFrontendDialog2(
      context,
      'Enable this licence plate?',
      [
        const Text(
          'You can only enable this licence plate when you are the owner of this licence plate. You can verify your ownership by uploading the registration certificate of your licence plate. Continue by clicking Next.',
        ),
        Row(
          children: [
            const Text('Why do we ask this?'),
            TextButton(
              onPressed: () => context.push(
                '/home/profile/licence-plates/explication',
              ),
              child: const Text(
                'See here why.',
                style: TextStyle(
                  color: Colors.indigoAccent,
                ),
              ),
            )
          ],
        ),
      ],
      () => handleEnableLicencePlate(licencePlate),
      leftButtonText: 'Next',
    );
  }

  void handleEnableLicencePlate(LicencePlate licencePlate) {
    context.pop();
    context.push(
      '/home/profile/licence-plates/enable',
      extra: licencePlate,
    );
  }
}
