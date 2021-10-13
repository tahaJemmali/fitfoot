import 'dart:convert';

List<RoutineList> RoutineListFromJson(String str) => List<RoutineList>.from(
    json.decode(str).map((x) => RoutineList.fromJson(x)));

String RoutineListToJson(List<RoutineList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutineList {
  RoutineList({
    this.id,
    this.userid,
    this.medname,
    this.medid,
  });

  String id;
  String userid;
  String medid;
  String medname;

  factory RoutineList.fromJson(Map<String, dynamic> json) => RoutineList(
        id: json["_id"],
        userid: json["userid"],
        medid: json["medid"],
        medname: json["medname"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userid": userid,
        "medid": medid,
        "medname": medname,
      };
}
