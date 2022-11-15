class User {
  final int id;
  final String email;
  final int role;
  final String? firstName;
  final String? lastName;
  final String token;
  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.token,
  });
  static User userFromJson(Map<String, dynamic> json) {
    return User(
        id: json["user"]["id"] as int,
        email: json["user"]["email"] as String,
        role: json["user"]["role"] as int,
        firstName: json["user"]["firstName"] as String?,
        lastName: json["user"]["lastName"] as String?,
        token: json["token"] as String);
  }

  get_mail() {
    return email;
  }
}
//List<User> userListFromJson(json) => (json as List)
//    .map((jsonUser) =>
//    User.userFromJson(jsonUser as Map<String, dynamic>))
//    .toList();