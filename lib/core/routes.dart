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
import 'package:po_frontend/pages/home/notifications.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/confirm_licence_plate.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/explication_page.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/licence_plates.dart';
import 'package:po_frontend/pages/navbar/profile/licence_plates/report_licence_place.dart';
import 'package:po_frontend/pages/navbar/profile/user_info/user_info.dart';
import 'package:po_frontend/pages/payment_page/failed_payment_page.dart';
import 'package:po_frontend/pages/payment_page/succesful_payment_page.dart';
import 'package:po_frontend/pages/reservations/confirm_reservation.dart';
import 'package:po_frontend/pages/reservations/make_reservation_page.dart';
import 'package:po_frontend/pages/reservations/select_licence_plate.dart';
import 'package:po_frontend/pages/reservations/user_reservations.dart';
import 'package:po_frontend/pages/navbar/profile/profile.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_settings_page.dart';
import 'package:po_frontend/pages/settings/user_settings/add_automatic_payment_page.dart';
import 'package:po_frontend/pages/settings/user_settings/add_two_factor_device_page.dart';
import 'package:po_frontend/pages/reservations/spot_selection.dart';
import 'package:po_frontend/pages/settings/user_settings/user_settings_page.dart';
import 'package:po_frontend/utils/loading_page.dart';
import 'package:po_frontend/pages/navbar/profile/user_info/change_password.dart';
import 'package:po_frontend/pages/navbar/profile/user_info/change_province.dart';

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
              path: 'settings/garage/:garageId',
              builder: (context, state) => GarageSettingsPage(
                garageId: int.parse(state.params['garageId']!),
              ),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const UserSettingsPage(),
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
                  path: 'change-password',
                  builder: (context, state) => const ChangePasswordPage(),
                ),
                GoRoute(
                  path: 'change-province',
                  builder: (context, state) => const ChangeProvincePage(),
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
                    GoRoute(
                      path: 'report',
                      builder: (context, state) => ReportLicencePlatePage(
                        licencePlate: state.extra as String,
                      ),
                    ),
                    GoRoute(
                      path: 'explication',
                      builder: (context, state) => const ExplicationPage(),
                    )
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'notifications',
              builder: (context, state) => const NotificationPage(),
            )
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
            builder: (context, state) => const SuccessFulPaymentPage(),
          ),
          GoRoute(
            path: 'failed',
            builder: (context, state) => const FailedPaymentPage(),
          ),
        ])
      ],
    );
  }
}
