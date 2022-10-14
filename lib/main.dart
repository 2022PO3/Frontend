import 'package:flutter/material.dart';
import 'package:po_frontend/pages/NavBar_Pages/My_Reservations.dart';
import 'pages/home/HomePage.dart';
import 'pages/loading.dart';
import 'pages/NavBar_Pages/My_Reservations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => MyHomePage(),
        '/My_Reservations': (context) => My_Reservations(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
