import 'package:flutter/material.dart';

class Spot_Selection extends StatefulWidget {
  const Spot_Selection({Key? key}) : super(key: key);

  @override
  State<Spot_Selection> createState() => _Spot_SelectionState();
}

class _Spot_SelectionState extends State<Spot_Selection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spot Selection'),
      ),
    );
  }
}
