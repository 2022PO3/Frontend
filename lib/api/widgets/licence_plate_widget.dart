// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';

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

Widget buildOverviewLicencePlateWidget(LicencePlate licencePlate) {
  final bool enabled = licencePlate.enabled;
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
                  licencePlate.formatLicencePlate(),
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
  );
}

void showEnableLicencePlatePopUp(
  BuildContext context,
  LicencePlate licencePlate,
) {
  if (!licencePlate.enabled) {
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
      () => handleEnableLicencePlate(context, licencePlate),
      leftButtonText: 'Next',
    );
  }
}

void handleEnableLicencePlate(
  BuildContext context,
  LicencePlate licencePlate,
) {
  context.pop();
  context.push(
    '/home/profile/licence-plates/enable',
    extra: licencePlate,
  );
}
