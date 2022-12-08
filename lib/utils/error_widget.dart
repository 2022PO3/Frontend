import 'package:flutter/material.dart';

class SnapshotErrorWidget extends StatelessWidget {
  const SnapshotErrorWidget({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
}
