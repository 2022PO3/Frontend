import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register.dart';

import 'pages/loading_screen.dart';
import 'pages/home/home_page.dart';
import 'pages/navbar/settings.dart';
import 'pages/navbar/statistics.dart';
import 'pages/navbar/profile.dart';
import 'pages/navbar/help.dart';
import 'pages/navbar/my_reservations.dart';
import 'pages/booking_system.dart';

import 'pages/garage_info.dart';

import 'providers/user_provider.dart';
import 'api/garages_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo[50]),
      initialRoute: '/loading_screen',
      routes: {
        '/loading_screen': ((context) => const LoadingScreen()),
        '/login_page': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(),
        '/my_Reservations': (context) => const MyReservations(),
        '/settings': (context) => const Settings(),
        '/statistics': (context) => const Statistics(),
        '/profile': (context) => const Profile(),
        '/help': (context) => const HelpF(),
        '/booking_system': (context) => const BookingSystem(),
        '/garages_page': (context) => const GaragesPage(),
        '/register': (context) => const RegisterNow(),
        '/garage_info': (context) => const GarageInfo(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
