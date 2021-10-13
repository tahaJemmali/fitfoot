import 'dart:convert';
import 'dart:ffi';

import 'package:workspace/Login/utils/constants.dart';

import '../Login/utils/constants.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailDoctor,
    this.emailVerification,
    this.password,
    this.birthDate,
    this.phone,
    this.phoneDoctor,
    this.gender,
    this.height,
    this.weight,
    this.photo,
    this.address,
    this.signUpDate,
    this.lastLoginDate,
  });
  String id;
  String firstName;
  String lastName;
  String email;
  String emailDoctor;
  bool emailVerification;
  String password;
  DateTime birthDate;
  String phone;
  String phoneDoctor;
  String photo;

  Gender gender;
  double height;
  double weight;

  String address;
  DateTime signUpDate;
  DateTime lastLoginDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        emailDoctor: json["emailM"] == null ? "null" : json["emailM"],
        emailVerification: json["emailVerification"],
        password: json["password"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        phone: json["phone"] == null ? "null" : json["phone"],
        phoneDoctor: json["phoneDoctor"] == null ? "null" : json["phoneDoctor"],
        height: json["height"] == null
            ? -1
            : double.parse((json["height"].toString()).replaceAll(',', '')),
        weight: json["weight"] == null
            ? -1
            : double.parse((json["weight"].toString()).replaceAll(',', '')),
        gender: json["gender"] == null
            ? Gender.Homme
            : Gender.values.firstWhere((f) => f.toString() == json["gender"],
                orElse: () => Gender.Homme),
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
        "_id": id == null ? "null" : id,
        "firstName": firstName == null ? "null" : firstName,
        "lastName": lastName == null ? "null" : lastName,
        "email": email == null ? "null" : email,
        "emailDoctor": emailDoctor == null ? "null" : emailDoctor,
        "emailVerification":
            emailVerification == null ? "true" : emailVerification.toString(),
        "password": password == null ? "null" : password,
        "birthDate": birthDate == null ? "null" : birthDate.toIso8601String(),
        "phone": phone == null ? "null" : phone,
        "phoneDoctor": phoneDoctor == null ? "null" : phoneDoctor,
        "weight": weight == null ? "-1" : weight.toString(),
        "height": height == null ? "-1" : height.toString(),
        "gender": gender == null ? Gender.Homme.toString() : gender.toString(),
        "photo": photo == null ? "null" : photo,
        "address": address == null ? "null" : address,
        "signUpDate":
            signUpDate == null ? "null" : signUpDate.toIso8601String(),
        "lastLoginDate":
            lastLoginDate == null ? "null" : lastLoginDate.toIso8601String(),
      };
}
