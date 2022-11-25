import 'package:po_frontend/api/models/enums.dart';

class User {
  final int id;
  final String email;
  final int role;
  final String? firstName;
  final String? lastName;
  final int? favGarageId;
  final ProvinceEnum? location;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.favGarageId,
    required this.location,
  });

  static User userFromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      email: json["email"] as String,
      role: json["role"] as int,
      firstName: json["firstName"] as String?,
      lastName: json["lastName"] as String?,
      favGarageId: json["favGarageId"] as int?,
      location: json["location"] as ProvinceEnum?,
    );
  }

  static List loginUserFromJson(Map<String, dynamic> json) {
    return [
      User(
        id: json["user"]["id"] as int,
        email: json["user"]["email"] as String,
        role: json["user"]["role"] as int,
        firstName: json["user"]["firstName"] as String?,
        lastName: json["user"]["lastName"] as String?,
        favGarageId: json["user"]["favGarageId"] as int?,
        location: json["user"]["location"] as ProvinceEnum?,
      ),
      json['token']
    ];
  }
}
//List<User> userListFromJson(json) => (json as List)
//    .map((jsonUser) =>
//    User.userFromJson(jsonUser as Map<String, dynamic>))
//    .toList();
