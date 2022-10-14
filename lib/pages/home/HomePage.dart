import 'package:flutter/material.dart';
import 'NavBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: NavBar(),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              child: ClipOval(
                //Hier komt de profielfoto
              ),
            ),
          ),

          title: Text("test"),
        ),
        body: Text("test")
    );
  }
}




