import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/models/garage_model.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/network/network_helper.dart';
import '../../api/network/network_service.dart';
import '../../api/network/static_values.dart';
import '../../api/requests/payment_requests.dart';
import '../payment_page/payment_page.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.licencePlate,
    this.isPreview = false,
    required this.garage,
  });

  final LicencePlate licencePlate;
  final Garage garage;
  final bool isPreview;

  void onPressed(BuildContext context) {
    if (isPreview) {
      Navigator.of(context).push(
        ScaleRoute(
          page: PaymentPage(
            licencePlate: licencePlate,
            garage: garage,
          ),
        ),
      );
    } else {
      startPaymentSession(licencePlate: licencePlate.licencePlate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pay_button_${licencePlate.licencePlate}',
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(StadiumBorder()),
          ),
          onPressed: () => onPressed(context),
          child: const Text('Pay')),
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
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
