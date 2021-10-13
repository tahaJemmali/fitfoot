import 'dart:convert';

List<MedList> MedListFromJson(String str) =>
    List<MedList>.from(json.decode(str).map((x) => MedList.fromJson(x)));

String MedListToJson(List<MedList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

MedList medFromJson(String str) => MedList.fromJson(json.decode(str));
String medToJson(MedList data) => json.encode(data.toJson());

class MedList {
  MedList({
    this.id,
    this.name,
    this.type,
    this.nb,
    this.creatorid,
  });

  String id;
  String name;
  String type;
  String creatorid;
  int nb;

  factory MedList.fromJson(Map<String, dynamic> json) => MedList(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        creatorid: json["creatorid"],
        nb: json["nb"],
      );

  factory MedList.medFromJson(Map<String, dynamic> json) => MedList(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        nb: json["nb"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "creatorid": creatorid,
        "nb": nb,
      };

  factory MedList.onefromJson() => MedList();
}
