import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SuccessFulPaymentPage extends StatelessWidget {
  const SuccessFulPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 10),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            const Spacer(),
            Text(
              'Your payment was successful',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.shortestSide / 15,
              ),
            ),
            Text(
              'You can now leave the garage',
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
      ),
    );
  }
}

class ReturnToAppButton extends StatelessWidget {
  const ReturnToAppButton({Key? key, required this.text, this.route = '/'})
      : super(key: key);
  final String text;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (kIsWeb) {
          try {
            launchUrlString('https://po3backend.ddns.net/app$route');
          } catch (e) {
            context.go('/home');
          }
        } else {
          context.go('/home');
        }
      },
      child: Text(text),
    );
  }
}
