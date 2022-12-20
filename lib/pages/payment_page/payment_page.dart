// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/pages/payment_widgets/pay_button.dart';

import '../../api/models/garage_model.dart';
import '../payment_widgets/payment_overview.dart';
import '../payment_widgets/timer_widget.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    Key? key,
    required this.licencePlate,
    required this.garage,
  }) : super(key: key);

  final LicencePlate licencePlate;
  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              title: const Text('Checkout'),
            ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _Header(
                garage: garage,
                licencePlate: licencePlate,
              ),
              //const Divider(),
              const Spacer(),
              Expanded(
                flex: 20,
                child: PaymentOverview(
                  licencePlate: licencePlate,
                ),
              ),
              // const Divider(),
              const Spacer(),
              _CompletionButtons(
                licencePlate: licencePlate,
                garage: garage,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionButtons extends StatelessWidget {
  /// Buttons at the bottom of the page to finalize payment. On browsers there
  /// is an extra cancel button because the page won't have an appbar to return.

  const _CompletionButtons({
    required this.licencePlate,
    required this.garage,
  });

  final LicencePlate licencePlate;
  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        if (kIsWeb)
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const StadiumBorder(),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ),
        if (kIsWeb) const Spacer(),
        Expanded(
          flex: 4,
          child: PayButton(
            licencePlate: licencePlate,
            garage: garage,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  /// Top row of the payment page, it contains the name of the garage and a
  /// timer counting how long the user has parked in the garage.

  const _Header({
    required this.garage,
    required this.licencePlate,
  });

  final Garage garage;
  final LicencePlate licencePlate;

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Hero(
              tag: 'title_${licencePlate.licencePlate}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Complete your parking session with ${licencePlate.formatLicencePlate()}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: shortestSide / 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Hero(
          tag: 'timer_${licencePlate.licencePlate}',
          child: TimerWidget(
            start: licencePlate.enteredAt!,
            textStyle: TextStyle(
              fontSize: shortestSide / 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        )
      ],
    );
  }
}
