import 'dart:convert';

List<IntakeList> IntakeListFromJson(String str) =>
    List<IntakeList>.from(json.decode(str).map((x) => IntakeList.fromJson(x)));

String IntakeListToJson(List<IntakeList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IntakeList {
  IntakeList({
    this.id,
    this.userid,
    this.medid,
    this.medname,
    this.date,
    this.checked,
  });
  IntakeList.f(String idd, String useridd, String mednamee, bool checkedd) {
    this.id = idd;
    this.userid = useridd;
    this.medid = medid;
    this.medname = mednamee;
    this.checked = checkedd;
  }

  String id;
  String medid;
  String userid;
  String medname;
  DateTime date;
  bool checked;

  factory IntakeList.fromJson(Map<String, dynamic> json) => IntakeList(
        id: json["_id"],
        medid: json["medid"],
        userid: json["userid"],
        medname: json["medname"],
        date: DateTime.parse(json["date"]),
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "medid": medid,
        "userid": userid,
        "medname": medname,
        "date": date,
        "checked": checked,
      };
}
