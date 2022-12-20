// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/base_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/dialogs.dart';

Widget buildEditItemsScreen<T extends BaseModel>({
  required String title,
  required Widget Function(T item) itemWidget,
  required Future<Object?>? future,
  required Future<void> Function() refreshFunction,
  void Function(BuildContext context, T item)? editFunction,
  bool addButton = false,
  void Function()? addFunction,
}) {
  return Scaffold(
    appBar: appBar(
      title: title,
      refreshButton: true,
      refreshFunction: refreshFunction,
    ),
    body: RefreshIndicator(
      onRefresh: refreshFunction,
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<T> items = snapshot.data as List<T>;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics().applyTo(
                const BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                return buildEditAndDeleteItemWidget(
                  context: context,
                  item: items[index],
                  refreshFunction: refreshFunction,
                  child: itemWidget(items[index]),
                  editFunction: editFunction,
                );
              },
              itemCount: items.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ),
    floatingActionButton: addButton
        ? FloatingActionButton(
            onPressed: addFunction,
            child: const Icon(Icons.add_rounded),
          )
        : null,
  );
}

Widget buildEditAndDeleteItemWidget<T extends BaseModel>({
  required BuildContext context,
  required T item,
  required Widget child,
  required void Function() refreshFunction,
  void Function(BuildContext context, T item)? editFunction,
}) {
  return InkWell(
    onLongPress: () => showDeletePopUp(context, item, refreshFunction),
    onTap: () => editFunction!(context, item),
    child: child,
  );
}

void showDeletePopUp<T extends BaseModel>(
  BuildContext context,
  T item,
  void Function() refreshFunction,
) {
  return showFrontendDialog2(
    context,
    'Delete this item?',
    [const Text('Are you sure that you want to delete this item?')],
    () => handleDelete(context, item, refreshFunction),
    leftButtonText: 'Yes',
    rightButtonText: 'No',
  );
}

void handleDelete<T extends BaseModel>(
  BuildContext context,
  T item,
  void Function() refreshFunction,
) {
  try {
    item.delete(context);
  } on BackendException catch (e) {
    context.pop();
    showFailureDialog(context, e);
  }
  context.pop();
  refreshFunction();
}
