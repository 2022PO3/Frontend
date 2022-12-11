import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/models/garage_model.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/network/network_helper.dart';
import '../../api/network/network_service.dart';
import '../../api/network/static_values.dart';
import '../../api/requests/payment_requests.dart';
import '../../utils/error_widget.dart';
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

class RequestButton<T> extends StatefulWidget {
  /// Button that makes a request to the backend, the makeRequest parameter
  /// should be a function that returns a future of T. While the future is
  /// loading, the button shows a progress indicator, when the future throws an
  /// error, the error is shown with a 'retry' button.
  const RequestButton({Key? key, required this.makeRequest, required this.text})
      : super(key: key);

  @override
  State<RequestButton> createState() => _RequestButtonState<T>();

  final Future<T> Function() makeRequest;
  final String text;
}

class _RequestButtonState<T> extends State<RequestButton> {
  Future<T>? future;

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return _buildButton(context, widget.text);
    }

    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'The request to our servers failed: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
              _buildButton(context, 'Retry')
            ],
          );
        } else {
          return _buildButton(context, widget.text);
        }
      },
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const StadiumBorder(),
            ),
          ),
          onPressed: () {
            setState(() {
              future = widget.makeRequest() as Future<T>?;
            });
          },
          child: Text(text)),
    );
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
