import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [(Colors.indigo), (Colors.indigoAccent)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
        ),
          ),
      body: const Text('Statistics'),
    );
  }
}
