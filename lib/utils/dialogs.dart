import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/utils/constants.dart';

void showFrontendDialog2(
  BuildContext context,
  String title,
  List<Widget> children,
  Function() leftButtonFunction, {
  leftButtonText = 'OK',
  rightButtonText = 'Cancel',
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: Constants.cardBorder,
        title: Text(title),
        contentPadding: const EdgeInsets.only(
          top: 10,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...children,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            Constants.cardBorderRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        leftButtonText,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () => leftButtonFunction(),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                            Constants.cardBorderRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        rightButtonText,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () => context.pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void showFrontendDialog1(
  BuildContext context,
  String title,
  List<Widget> children, {
  buttonText = 'OK',
  Function()? buttonFunction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
        ),
        shape: Constants.cardBorder,
        title: Text(title),
        contentPadding: const EdgeInsets.only(
          top: 15,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  ...children,
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            Constants.cardBorderRadius,
                          ),
                          bottomRight: Radius.circular(
                            Constants.cardBorderRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      buttonFunction != null ? buttonFunction() : context.pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class FrontendDialog extends AlertDialog {}

void showFailureDialog(BuildContext context, BackendException error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Server exception'),
        content: Text(
            'We\'re sorry, but the server returned an error: ${error.toString()}.'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

void showSuccessDialog(BuildContext context, String title, String body) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
