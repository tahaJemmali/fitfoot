import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerification,
    this.password,
    this.birthDate,
    this.phone,
    this.photo,
    this.address,
    this.signUpDate,
    this.lastLoginDate,
  });

  String firstName;
  String lastName;
  String email;
  bool emailVerification;
  String password;
  DateTime birthDate;
  String phone;
  String photo;
  String address;
  DateTime signUpDate;
  DateTime lastLoginDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        emailVerification: json["emailVerification"],
        password: json["password"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        phone: json["phone"] == null ? "null" : json["phone"],
        photo: json["photo"] == null ? "null" : json["photo"],
        address: json["address"] == null ? "null" : json["address"],
        signUpDate: json["signUpDate"] == null
            ? null
            : DateTime.parse(json["signUpDate"]),
        lastLoginDate: json["lastLoginDate"] == null
            ? null
            : DateTime.parse(json["lastLoginDate"]),
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName == null ? "null" : firstName,
        "lastName": lastName == null ? "null" : lastName,
        "email": email == null ? "null" : email,
        "emailVerification":
            emailVerification == null ? "false" : emailVerification,
        "password": password == null ? "null" : password,
        "birthDate": birthDate == null ? "null" : birthDate.toIso8601String(),
        "phone": phone == null ? "null" : phone,
        "photo": photo == null ? "null" : photo,
        "address": address == null ? "null" : address,
        "signUpDate":
            signUpDate == null ? "null" : signUpDate.toIso8601String(),
        "lastLoginDate":
            lastLoginDate == null ? "null" : lastLoginDate.toIso8601String(),
      };
}
