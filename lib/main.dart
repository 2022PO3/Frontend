import 'package:flutter/material.dart';
import 'package:po_frontend/core/routes.dart';
import 'package:po_frontend/pages/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/pages/confirm_reservation.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/pages/make_reservation_page.dart';
import 'package:po_frontend/pages/spot_selection.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register.dart';
import 'pages/auth/user_activation_page.dart';
import 'pages/auth/two_factor_page.dart';

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

List stripParameters(String? routeName) {
  if (routeName == null) {
    return [routeName];
  }
  Map<String, String> queryParams =
      Uri.parse(routeName.replaceAll('#', '')).queryParameters;
  return [routeName.replaceAll(RegExp(r'\?.*'), ''), queryParams];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialLocation = '/login';
  LoginStatus loginStatus = await AuthService.checkLogin();

  switch (loginStatus) {
    case LoginStatus.unAuthenticated:
      break;
    case LoginStatus.authenticated:
      initialLocation = '/login/two-factor';
      break;
    case LoginStatus.verified:
      initialLocation = '/home';
      break;
  }

  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MyApp(
        initialLocation: initialLocation,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialLocation,
  });

  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Parking Boys',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo[50],
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.generateRoutes(initialLocation),
    );
    /*
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo[50]),
      home: defaultHome,
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        'home': (context) => const HomePage(),
        '/my_Reservations': (context) => const MyReservations(),
        '/settings': (context) => const UserSettings(),
        '/statistics': (context) => const Statistics(),
        '/profile': (context) => const Profile(),
        '/help': (context) => const HelpF(),
        '/booking_system': (context) => const BookingSystem(),
        '/garages_page': (context) => const GaragesPage(),
        'login/register': (context) => const RegisterPage(),
        '/garage_info': (context) => const GarageInfo(),
          '/New_Reservation': (context) => New_Reservation(),
          '/Spot_Selection': (context) => Spot_Selection(),
          '/Confirm_Reservation': (context) => Confirm_Reservation(),
        TwoFactorPage.route: (context) => const TwoFactorPage(),
        AddTwoFactorDevicePage.route: (context) =>
            const AddTwoFactorDevicePage(),
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        List stripResult = stripParameters(settings.name);
        print(stripResult);
        if (stripResult[0] == '/') {
          Map<String, String> args = stripResult[1];
          if (args['email'] == null || args['password'] == null) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => LoadingScreen(
                email: args['email']!,
                password: args['password']!,
              ),
            );
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
    */
  }
}
