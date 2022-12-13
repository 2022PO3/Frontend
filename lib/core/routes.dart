import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/models/reservation_model.dart';
import 'package:po_frontend/pages/auth/login_page.dart';
import 'package:po_frontend/pages/auth/register.dart';
import 'package:po_frontend/pages/auth/two_factor_page.dart';
import 'package:po_frontend/pages/auth/user_activation_page.dart';
import 'package:po_frontend/pages/garage_info.dart';
import 'package:po_frontend/pages/home/home_page.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/confirm_licence_plate.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/licence_plates.dart';
import 'package:po_frontend/pages/navbar/profile/user_info.dart';
import 'package:po_frontend/pages/payment_page/failed_payment_page.dart';
import 'package:po_frontend/pages/reservations/confirm_reservation.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/pages/reservations/select_licence_plate.dart';
import 'package:po_frontend/pages/reservations/user_reservations.dart';
import 'package:po_frontend/pages/navbar/profile/profile.dart';
import 'package:po_frontend/pages/navbar/statistics.dart';
import 'package:po_frontend/pages/settings/add_automatic_payment_page.dart';
import 'package:po_frontend/pages/settings/add_two_factor_device_page.dart';
import 'package:po_frontend/pages/settings/user_settings.dart';
import 'package:po_frontend/pages/reservations/spot_selection.dart';
import 'package:po_frontend/utils/loading_page.dart';

import '../pages/payment_page/succesful_payment_page.dart';

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
          routes: [
            GoRoute(
              path: 'settings',
              builder: (context, state) => const UserSettings(),
              routes: [
                GoRoute(
                  path: 'two-factor',
                  builder: (context, state) => const AddTwoFactorDevicePage(),
                ),
                GoRoute(
                  path: 'add-automatic-payment',
                  builder: (context, state) => const AddAutomaticPaymentPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'garage-info/:garageId',
              builder: (context, state) => GarageInfoPage(
                garageId: int.parse(state.params['garageId']!),
              ),
            ),
            GoRoute(
              path: 'select-licence-plate',
              builder: (context, state) => SelectLicencePlatePage(
                garage: state.extra as Garage,
              ),
            ),
            GoRoute(
              path: 'reserve',
              builder: (context, state) => MakeReservationPage(
                garageAndLicencePlate: state.extra as GarageAndLicencePlate,
              ),
              routes: [
                GoRoute(
                  path: 'spot-selection',
                  builder: (context, state) => SpotSelectionPage(
                    garageLicenceAndTime:
                        state.extra as GarageLicencePlateAndTime,
                  ),
                ),
                GoRoute(
                  path: 'confirm-reservation',
                  builder: (context, state) => ConfirmReservationPage(
                    reservation: state.extra as Reservation,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'reservations',
              builder: (context, state) => const UserReservations(),
            ),
            GoRoute(
              path: 'profile',
              builder: (context, state) => const Profile(),
              routes: [
                GoRoute(
                  path: 'user-info',
                  builder: (context, state) => const UserInfo(),
                ),
                GoRoute(
                  path: 'licence-plates',
                  builder: (context, state) => const LicencePlatesPage(),
                  routes: [
                    GoRoute(
                      path: 'enable',
                      builder: (context, state) => ConfirmLicencePlatePage(
                        licencePlate: state.extra as LicencePlate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(
            email: state.queryParams['email'],
            password: state.queryParams['password'],
          ),
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
        GoRoute(
          path: '/user-activation',
          builder: (context, state) => UserActivationPage(
            uidB64: state.queryParams['uidB64'],
            token: state.queryParams['token'],
          ),
        ),
        GoRoute(path: '/checkout', redirect: (_, __) => '/', routes: [
          GoRoute(
              path: 'success',
              builder: (context, state) => const SuccessFulPaymentPage()),
          GoRoute(
              path: 'failed',
              builder: (context, state) => const FailedPaymentPage()),
        ])
      ],
    );
  }
}
