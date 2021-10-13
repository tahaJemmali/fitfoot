// To parse this JSON data, do
//
//     final statsA = statsAFromJson(jsonString);

import 'dart:convert';

import 'mesure.dart';

StatsA statsAFromJson(String str) => StatsA.fromJson(json.decode(str));

String statsAToJson(StatsA data) => json.encode(data.toJson());

class StatsA {
  StatsA({
    this.lastMesure,
  });

  List<Mesure> lastMesure;

  factory StatsA.fromJson(Map<String, dynamic> json) => StatsA(
        lastMesure: List<Mesure>.from(
            json["lastMesure"].map((x) => Mesure.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastMesure": List<dynamic>.from(lastMesure.map((x) => x.toJson())),
      };
}
