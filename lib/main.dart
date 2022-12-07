import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register.dart';
import 'pages/auth/user_activation_page.dart';
import 'pages/auth/two_factor_page.dart';

import 'pages/loading_screen.dart';
import 'pages/home/home_page.dart';
import 'pages/settings/user_settings.dart';
import 'pages/navbar/statistics.dart';
import 'pages/navbar/profile.dart';
import 'pages/navbar/help.dart';
import 'pages/navbar/my_reservations.dart';
import 'pages/booking_system.dart';
import 'pages/settings/add_two_factor_device_page.dart';

import 'pages/garage_info.dart';

import 'providers/user_provider.dart';
import 'api/garages_page.dart';

List stripParameters(String? routeName) {
  if (routeName == null) {
    return [routeName];
  }
  Map<String, String> queryParams =
      Uri.parse(routeName.replaceAll('#', '')).queryParameters;
  return [routeName.replaceAll(RegExp(r'\?.*'), ''), queryParams];
}

void main() {
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo[50]),
      home: const LoadingScreen(),
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(),
        '/my_Reservations': (context) => const MyReservations(),
        '/settings': (context) => const UserSettings(),
        '/statistics': (context) => const Statistics(),
        '/profile': (context) => const Profile(),
        '/help': (context) => const HelpF(),
        '/booking_system': (context) => const BookingSystem(),
        '/garages_page': (context) => const GaragesPage(),
        '/register': (context) => const RegisterNow(),
        '/garage_info': (context) => const GarageInfo(),
        TwoFactorPage.route: (context) => const TwoFactorPage(),
        AddTwoFactorDevicePage.route: (context) =>
            const AddTwoFactorDevicePage(),
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        List stripResult = stripParameters(settings.name);
        print(stripResult);
        if (stripResult[0] == '/${UserActivationPage.route}') {
          Map<String, String> args = stripResult[1];
          if (args['uidB64'] == null || args['token'] == null) {
            throw Exception(
                'Either `uidB64` or `token`-parameters is not given to the url!');
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => UserActivationPage(
              uidB64: args['uidB64']!,
              token: args['token']!,
            ),
          );
        }
        return null;
      },
    );
  }
}
