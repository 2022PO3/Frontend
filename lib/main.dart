import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register.dart';
import 'pages/auth/user_activation_page.dart';

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
  String appUrl = Uri.base.toString(); //get complete url
  Map<String, String> queryParams =
      Uri.base.queryParameters; //get parameter with attribute "para1"
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: MyApp(queryParams: queryParams),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.queryParams,
  });

  final Map<String, String> queryParams;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo[50]),
      initialRoute: '/user-activation',
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
        '/user-activation': (context) => UserActivationPage(
              queryParams: queryParams,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
