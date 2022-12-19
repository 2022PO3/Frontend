import 'package:intl/intl.dart';

class StaticValues {
  const StaticValues._();
  // Garage slugs
  static const String garagesDetailSlug = 'api/garage';
  static const String garagesListSlug = 'api/garages';

  // Opening Hours
  static const String openingHoursListSlug = 'api/opening-hours';

  // Parking lots
  static const String getParkingLotsSlug = 'api/parking-lots';
  static const String assignParkingLotSlug = 'api/assign-parking-lot';

  // Auth slugs
  static const String loginSlug = 'api/auth/login';
  static const String userSlug = 'api/user';
  static const String logOutSlug = 'api/auth/logout';
  static const String registerSlug = 'api/auth/sign-up';
  static const String changePasswordSlug = 'api/user/change-password';
  static const String activateUserSlug = 'api/auth/activate-account';

  // Prices
  static const String pricesDetailSlug = 'api/price';
  static const String pricesListSlug = 'api/prices';

  // Reservations
  static const String reservationsDetailSlug = 'api/reservation';
  static const String reservationsListSlug = 'api/reservations';

  // Licence plates
  static const String licencePlatesDetailSlug = 'api/licence-plate';
  static const String licencePlatesListSlug = 'api/licence-plates';

  // Payment slugs
  static const String createPaymentSessionSlug = 'api/checkout/create-session';
  static const String getPaymentPreviewSlug = 'api/checkout/preview';
  static const String stripeConnectionSlug = 'api/stripe-connection';

  // Two factor slugs
  static const String totpListSlug = 'api/auth/totp';
  static const String twoFactorDevicesSlug = 'api/auth/totp';
  static const String sendAuthenticationCodeSlug = 'api/auth/totp/login';
  static const String disable2FASlug = 'api/auth/totp/disable';

  // Notifications
  static const String notificationsDetailSlug = 'api/notification';
  static const String notificationsListSlug = 'api/notifications';

  // Offset for reservations
  static const Duration offset = Duration(hours: 8);

  // Default date format
  static DateFormat frontendDateFormat = DateFormat('HH:mm, dd/MM/y');

  // Custom settings
  static const bool debug = true;
  static const bool overrideServerUrl = true;
  static const String localURL = 'http://192.168.49.1:8000/';
}
