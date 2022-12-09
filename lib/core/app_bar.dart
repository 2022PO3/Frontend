import 'package:flutter/material.dart';

AppBar appBar(String title, bool refreshButton, Function? setState) {
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
    title: Text(
      title,
    ),
    actions: refreshButton
        ? [
            IconButton(
              onPressed: () {
                setState!(() {});
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          ]
        : [],
  );
}
