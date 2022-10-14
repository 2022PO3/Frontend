import 'package:flutter/material.dart';
import 'package:po_frontend/pages/NavBar_Pages/My_Reservations.dart';
import 'pages/home/HomePage.dart';
import 'pages/loading.dart';
import 'package:po_frontend/pages/NavBar_Pages/Settings.dart';
import 'package:po_frontend/pages/NavBar_Pages/Sign_Out.dart';
import 'package:po_frontend/pages/NavBar_Pages/Statistics.dart';
import 'package:po_frontend/pages/NavBar_Pages/Profile.dart';

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
        '/settings': (context) => Settings(),
        '/sign_out': (context) => Sign_Out(),
        '/statistics': (context) => Statistics(),
        '/profile': (context) => Profile(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
