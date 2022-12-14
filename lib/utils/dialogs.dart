import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/utils/constants.dart';

void showFailureDialog(BuildContext context, BackendException error) {
  return showFrontendDialog1(
    context,
    'Server Exception',
    [
      Text(
          'We\'re sorry, but the server returned an error: ${error.toString()}.'),
    ],
  );
}

void showSuccessDialog(BuildContext context, String title, String body) {
  return showFrontendDialog1(
    context,
    title,
    [Text(body)],
  );
}

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
        titlePadding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
        ),
        contentPadding: const EdgeInsets.only(
          top: 15,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...children,
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                buildDialogButton(
                  leftButtonText,
                  Colors.indigoAccent,
                  () => leftButtonFunction(),
                  leftBorderRadius: true,
                ),
                buildDialogButton(
                  rightButtonText,
                  Colors.red,
                  () => context.pop(),
                  rightBorderRadius: true,
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
              height: 20,
            ),
            Row(
              children: [
                buildDialogButton(
                  buttonText,
                  Colors.indigoAccent,
                  buttonFunction != null
                      ? () => buttonFunction()
                      : () => context.pop(),
                  leftBorderRadius: true,
                  rightBorderRadius: true,
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget buildDialogButton(
  String buttonText,
  Color buttonColor,
  Function() buttonFunction, {
  bool rightBorderRadius = false,
  bool leftBorderRadius = false,
}) {
  return Expanded(
    child: InkWell(
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.only(
            bottomLeft: leftBorderRadius
                ? const Radius.circular(
                    Constants.borderRadius,
                  )
                : const Radius.circular(0),
            bottomRight: rightBorderRadius
                ? const Radius.circular(
                    Constants.borderRadius,
                  )
                : const Radius.circular(0),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () => buttonFunction(),
    ),
  );
}
