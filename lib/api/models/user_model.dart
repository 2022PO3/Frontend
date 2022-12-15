import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/network/network_exception.dart';

class User {
  final int id;
  String email;
  final int role;
  String? firstName;
  String? lastName;
  int? favGarageId;
  ProvinceEnum? location;
  final bool hasAutomaticPayment;
  final bool twoFactor;
  final bool? twoFactorValidated;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.favGarageId,
    required this.location,
    required this.hasAutomaticPayment,
    required this.twoFactor,
    required this.twoFactorValidated,
  });

  get isGarageOwner => role == 2;

  static User fromJSON(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as int,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      favGarageId: json['favGarageId'] as int?,
      location: (json['province'] != null)
          ? ProvinceEnum.fromString(json['province'] as String)
          : null,
      hasAutomaticPayment: json['hasAutomaticPayment'] as bool,
      twoFactor: json['twoFactor'] as bool,
      twoFactorValidated: json['twoFactorValidated'] as bool?,
    );
  }

  static List loginFromJSON(Map<String, dynamic> json) {
    return [
      User(
        id: json['user']['id'] as int,
        email: json['user']['email'] as String,
        role: json['user']['role'] as int,
        firstName: json['user']['firstName'] as String?,
        lastName: json['user']['lastName'] as String?,
        favGarageId: json['user']['favGarageId'] as int?,
        location: (json['user']['location'] != null)
            ? ProvinceEnum.fromString(json['user']['location'] as String)
            : null,
        hasAutomaticPayment: json['user']['hasAutomaticPayment'] as bool,
        twoFactor: json['user']['twoFactor'] as bool,
        twoFactorValidated: json['user']['twoFactorValidated'] as bool?,
      ),
      json['token']
    ];
  }

  /// Extracts the secret key for the user from the JSOn backend response.
  static String extractSecret(Map<String, dynamic> json) {
    String otpAuthUrl = json['oauthUrl'];
    Uri otpAuthUri = Uri.parse(otpAuthUrl);
    Map<String, String> queryParams = otpAuthUri.queryParameters;
    String? secret = queryParams['secret'];
    if (secret == null) {
      throw BackendException(['Secret is not part of the oauth URL.']);
    }
    return secret;
  }

  Map<String, dynamic> toJSON() {
    return {
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'favGarageId': favGarageId,
      'location': location?.databaseValue
    };
  }
}
