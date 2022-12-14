import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/network_exception.dart';

void showFailureDialog(BuildContext context, BackendException error) {
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [...children],
              ),
            ),
            const SizedBox(
              height: 20,
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
