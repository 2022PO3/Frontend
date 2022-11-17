import 'package:flutter/material.dart';
import 'package:po_frontend/api/garages_page.dart';
import 'package:po_frontend/pages/NavBar_Pages/My_Reservations.dart';
import 'package:po_frontend/pages/loading_screen.dart';
import 'pages/home/HomePage.dart';
import 'pages/loading.dart';
import 'package:po_frontend/pages/NavBar_Pages/Settings.dart';
import 'package:po_frontend/pages/NavBar_Pages/Statistics.dart';
import 'package:po_frontend/pages/NavBar_Pages/Profile.dart';
import 'package:po_frontend/pages/NavBar_Pages/Help.dart';
import 'package:po_frontend/pages/Booking_System.dart';
import 'package:po_frontend/pages/login_page.dart';
import 'package:po_frontend/pages/Register.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/Providers/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        '/': (context) => const Loading(),
        '/login_page': (context) => Login_Page(),
        '/home': (context) => MyHomePage(),
        '/My_Reservations': (context) => My_Reservations(),
        '/settings': (context) => Settings(),
        '/statistics': (context) => const Statistics(),
        '/profile': (context) => Profile(),
        '/help': (context) => HelpF(),
        '/booking_system': (context) => Booking_System(),
        '/garages_page': (context) => const GaragesPage(),
        '/register': (context) => const Register_Now(),
        '/loading_screen': ((context) => const LoadingScreen())
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
