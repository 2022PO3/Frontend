import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/pages/payment_page/succesful_payment_page.dart';

class FailedPaymentPage extends StatelessWidget {
  const FailedPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 10),
              const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 50,
              ),
              const Spacer(),
              Text(
                'Your payment failed',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.shortestSide / 15,
                ),
              ),
              Text(
                'Please try again later',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: MediaQuery.of(context).size.shortestSide / 20,
                ),
              ),
              const Spacer(flex: 4),
              const ReturnToAppButton(text: 'Take me Home'),
              const Spacer(flex: 10),
            ],
          ),
        ],
      ),
    ));
  }
}
