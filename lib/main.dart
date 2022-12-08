import 'package:flutter/material.dart';
import 'package:po_frontend/core/routes.dart';
import 'package:po_frontend/pages/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

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
  }
}
