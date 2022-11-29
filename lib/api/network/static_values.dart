class StaticValues {
  const StaticValues._();
  static const String getGaragesSlug = 'api/garages?format=json';
  static const String getParkingLotsSlug = 'api/parking-lots/';
  static const String postLoginUser = 'api/auth/login';
  static const String getUserSlug = 'api/user';
  static const String postLogoutUser = 'api/auth/logout';
  static const String postRegisterUser = 'api/auth/sign-up';

  static const String activateUserSlug = 'api/auth/activate-account';
  static const String sendAuthenticationCodeSlug = 'api/auth/totp/login';

  static const bool debug = true;
}
