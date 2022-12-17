class StaticValues {
  const StaticValues._();
  // Garage slugs
  static const String garagesDetailSlug = 'api/garage';
  static const String getGaragesSlug = 'api/garages';
  static const String openingHoursListSlug = 'api/opening-hours';
  static const String pricesListSlug = 'api/prices';
  static const String pricesDetailSlug = 'api/price';
  static const String getParkingLotsSlug = 'api/parking-lots';
  static const String assignParkingLotSlug = 'api/assign-parking-lot';

  // Auth slugs
  static const String postLoginUser = 'api/auth/login';
  static const String userSlug = 'api/user';
  static const String postLogoutUser = 'api/auth/logout';
  static const String postRegisterUser = 'api/auth/sign-up';
  static const String changePassword = 'api/user/change-password';
  static const String activateUserSlug = 'api/auth/activate-account';

  // Reservation slugs
  static const String getReservationSlug = 'api/reservations';

  // Payment slugs
  static const String licencePlatesSlug = 'api/licence-plates';
  static const String createPaymentSessionSlug = 'api/checkout/create-session';
  static const String getPaymentPreviewSlug = 'api/checkout/preview';
  static const String stripeConnectionSlug = 'api/stripe-connection';

  // Two factor slugs
  static const String addTwoFactorDeviceSlug = 'api/auth/totp/create';
  static const String getTwoFactorDevicesSlug = 'api/auth/totp';
  static const String twoFactorDevicesSlug = 'api/auth/totp';
  static const String sendAuthenticationCodeSlug = 'api/auth/totp/login';
  static const String disable2FASlug = 'api/auth/totp/disable';

  // Misc
  static const String getNotificationsSlug = 'api/notifications';
  static const String pkNotificationsSlug = 'api/notification';

  // Custom settings
  static const bool debug = true;
  static const bool overrideServerUrl = true;
  static const String localURL = 'http://192.168.1.125:8000/';
}
