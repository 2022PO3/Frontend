// Flutter imports:
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
        ? [buildIconButton(refreshFunction, Icons.refresh_rounded)]
        : [],
  );
}

AppBar deleteAppBar<T>({
  String? title,
  required void Function() deleteFunction,
  bool edit = false,
  void Function()? editFunction,
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
    actions: edit
        ? [buildIconButton(editFunction, Icons.edit_rounded)]
        : [
            IconButton(
              onPressed: deleteFunction,
              icon: const Icon(Icons.delete_rounded),
            )
          ],
  );
}

IconButton buildIconButton(void Function()? onPressed, IconData icon) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(icon),
  );
}
