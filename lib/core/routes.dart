import 'package:go_router/go_router.dart';
import 'package:po_frontend/pages/auth/login_page.dart';
import 'package:po_frontend/pages/auth/register.dart';
import 'package:po_frontend/pages/auth/two_factor_page.dart';
import 'package:po_frontend/pages/home/home_page.dart';
import 'package:po_frontend/utils/loading_page.dart';

class Routes {
  static GoRouter generateRoutes(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoadingPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
              path: 'two-factor',
              builder: (context, state) => const TwoFactorPage(),
            ),
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterPage(),
            ),
          ],
        ),
      ],
    );
  }
}
