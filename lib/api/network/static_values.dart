class StaticValues {
  const StaticValues._();
  // Garage slugs
  static const String getGaragesSlug = 'api/garages';
  static const String getGarageSlug = 'api/garage';
  static const String getGarageOpeningHoursSlug = 'api/opening-hours';
  static const String getGaragePricesSlug = 'api/prices';
  static const String getGarageSettingsSlug = 'api/garage-settings';
  static const String getParkingLotsSlug = 'api/parking-lots';

  // Auth slugs
  static const String postLoginUser = 'api/auth/login';
  static const String getUserSlug = 'api/user';
  static const String postLogoutUser = 'api/auth/logout';
  static const String postRegisterUser = 'api/auth/sign-up';
  static const String activateUserSlug = 'api/auth/activate-account';

  // Reservation slugs
  static const String getReservationSlug = 'api/reservations';

  // Payment slugs
  static const String getLicencePlatesSlug = 'api/licence-plates';
  static const String createPaymentSessionSlug = 'api/checkout/create-session';
  static const String getPaymentPreviewSlug = 'api/checkout/preview';

  // Two factor slugs
  static const String addTwoFactorDeviceSlug = 'api/auth/totp/create';
  static const String getTwoFactorDevicesSlug = 'api/auth/totp';
  static const String twoFactorDevicesSlug = 'api/auth/totp';
  static const String sendAuthenticationCodeSlug = 'api/auth/totp/login';

  // Custom settings
  static const bool debug = true;
  static const bool overrideServerUrl = true;
}
