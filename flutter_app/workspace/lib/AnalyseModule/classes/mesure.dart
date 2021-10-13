import 'dart:convert';

import 'package:workspace/deviceModule/classes/pied.dart';

Mesure mesureFromJson(String str) => Mesure.fromJson(json.decode(str));

String mesureToJson(Mesure data) => json.encode(data.toJson());

class Mesure {
  Mesure({this.emailUser, this.date, this.pied1, this.pied2});
  String emailUser;
  DateTime date;
  Pied pied1;
  Pied pied2;

  factory Mesure.fromJson(Map<String, dynamic> json) => Mesure(
        emailUser: json["emailUser"],
        pied1: Pied.fromJson(json['pied1']),
        pied2: Pied.fromJson(json['pied2']),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "emailUser": emailUser == null ? "null" : emailUser,
        "pied1": pied1.id == null ? "null" : pied1.id,
        "pied2": pied2.id == null ? "null" : pied2.id,
        "date": date == null ? "null" : date.toIso8601String(),
      };
}
