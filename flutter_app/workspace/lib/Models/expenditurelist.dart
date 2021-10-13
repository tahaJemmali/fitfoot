import 'dart:convert';

List<ExpenditureList> ExpenditureListFromJson(String str) =>
    List<ExpenditureList>.from(
        json.decode(str).map((x) => ExpenditureList.fromJson(x)));

String ExpenditureListToJson(List<ExpenditureList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenditureList {
  ExpenditureList({
    this.id,
    this.duration,
    this.activityid,
    this.activityname,
    this.date,
    this.caloriesburned,
    this.userid,
  });
  ExpenditureList.f(String idd, double durationd, String activitynamee,
      String activityidd, double caloriesburnedd, String useridd) {
    this.id = idd;
    //this.duration = durationd;
    this.activityid = activityidd;
    this.activityname = activitynamee;
    this.caloriesburned = caloriesburnedd;
    this.userid = useridd;
  }

  String id;
  String activityid;
  int duration;
  String activityname;
  DateTime date;
  double caloriesburned;
  String userid;

  factory ExpenditureList.fromJson(Map<String, dynamic> json) =>
      ExpenditureList(
        id: json["_id"],
        activityid: json["activityid"],
        duration: json["duration"],
        activityname: json["activityname"],
        date: DateTime.parse(json["date"]),
        caloriesburned: json["caloriesburned"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "activityid": activityid,
        "duration": duration,
        "activityname": activityname,
        "date": date,
        "caloriesburned": caloriesburned,
        "userid": userid,
      };
}
