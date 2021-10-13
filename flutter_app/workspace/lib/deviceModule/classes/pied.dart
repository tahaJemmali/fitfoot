import 'dart:convert';

import 'package:workspace/deviceModule/classes/cote.dart';

Pied piedFromJson(String str) => Pied.fromJson(json.decode(str));

String piedToJson(Pied data) => json.encode(data.toJson());

class Pied {
  Pied(
      {this.id,
      this.cote,
      this.image,
      this.dimention,
      this.rougeur,
      this.temperature,
      this.etat,
      this.amelioration});
  String id;
  Cote cote;
  double temperature;
  double dimention;
  double rougeur;
  double etat;
  String image;
  double amelioration;

  factory Pied.fromJson(Map<String, dynamic> json) => Pied(
        id: json["_id"],
        cote: json["cote"] == "Cote.droit" ? Cote.droit : Cote.gauche,
        image: json["image"],
        dimention: json["dimention"] == null
            ? -1
            : double.parse((json["dimention"].toString())),
        rougeur: json["rougeur"] == null
            ? -1
            : double.parse((json["rougeur"].toString())),
        temperature: json["temperature"] == null
            ? -1
            : double.parse((json["temperature"].toString())),
        etat:
            json["etat"] == null ? -1 : double.parse((json["etat"].toString())),
        amelioration: json["amelioration"] == null
            ? -1
            : double.parse((json["amelioration"].toString())),
      );

  Map<String, dynamic> toJson() => {
        "cote": cote == null ? "null" : cote.toString(),
        "image": image == null ? "null" : image,
        "dimention": dimention == null ? "null" : dimention.toString(),
        "rougeur": rougeur == null ? "null" : rougeur.toString(),
        "temperature": temperature == null ? "null" : temperature.toString(),
        "etat": etat == null ? "null" : etat.toString(),
        "amelioration": amelioration == null ? "null" : amelioration.toString(),
      };
}
