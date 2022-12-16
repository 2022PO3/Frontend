import 'package:flutter/material.dart';
import '../../api/models/garage_model.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/requests/payment_requests.dart';
import '../../utils/request_button.dart';
import '../payment_page/payment_page.dart';

class PayPreviewButton extends StatelessWidget {
  /// Button to open payment preview page. It has a hero tag for a nice
  /// animation when opening the payment preview page.

  const PayPreviewButton({
    super.key,
    required this.licencePlate,
    required this.garage,
  });

  final LicencePlate licencePlate;
  final Garage garage;

  void onPressed(BuildContext context) {
    Navigator.of(context).push(
      ScaleRoute(
        page: PaymentPage(
          licencePlate: licencePlate,
          garage: garage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pay_button_${licencePlate.licencePlate}',
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const StadiumBorder()),
          ),
          onPressed: () => onPressed(context),
          child: const Text('Pay')),
    );
  }
}

class PayButton extends StatelessWidget {
  /// Button to launch the Stripe checkout url. It has a hero tag for a nice
  /// animation when opening the payment preview page.

  const PayButton({
    super.key,
    required this.licencePlate,
    required this.garage,
  });

  final LicencePlate licencePlate;
  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'pay_button_${licencePlate.licencePlate}',
        child: RequestButton<void>(
          makeRequest: () => startPaymentSession(
            licencePlate: licencePlate.licencePlate,
          ),
          text: 'Pay',
        ));
  }
}

class ScaleRoute extends PageRouteBuilder {
  /// Route for showing the payment preview page.
  final Widget page;
  ScaleRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubicEmphasized,
                ),
              ),
              child: child,
            ),
          ),
        );
}
