import 'package:flutter/material.dart';

AppBar appBar({
  String? title,
  bool refreshButton = false,
  Function()? refreshFunction,
}) {
  return AppBar(
    automaticallyImplyLeading: true,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [(Colors.indigo), (Colors.indigoAccent)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    ),
    title: title != null
        ? Text(
            title,
          )
        : null,
    actions: refreshButton
        ? [
            IconButton(
              onPressed: () {
                refreshFunction!();
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          ]
        : [],
  );
}
