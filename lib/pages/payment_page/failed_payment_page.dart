import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FailedPaymentPage extends StatelessWidget {
  const FailedPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 10),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
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
            ElevatedButton(
              onPressed: () {
                context.pop;
              },
              child: const Text('Take me home'),
            ),
            const Spacer(
              flex: 10,
            ),
          ],
        ),
      ),
    );
  }
}
