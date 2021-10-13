import 'dart:convert';

List<ActivityList> ActivityListFromJson(String str) => List<ActivityList>.from(
    json.decode(str).map((x) => ActivityList.fromJson(x)));

String ActivityListToJson(List<ActivityList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ActivityList ActivityFromJson(String str) =>
    ActivityList.fromJson(json.decode(str));
String ActivityToJson(ActivityList data) => json.encode(data.toJson());

class ActivityList {
  ActivityList({
    this.id,
    this.name,
    this.met,
  });

  String id;
  String name;
  double met;

  factory ActivityList.fromJson(Map<String, dynamic> json) => ActivityList(
        id: json["_id"],
        name: json["name"],
        met: json["met"],
      );

  factory ActivityList.ActivityFromJson(Map<String, dynamic> json) =>
      ActivityList(
        id: json["_id"],
        name: json["name"],
        met: json["met"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "met": met,
      };

  factory ActivityList.onefromJson() => ActivityList();
}
