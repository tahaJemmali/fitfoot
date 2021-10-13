import 'dart:convert';

List<AppointmentList> AppointmentListFromJson(String str) =>
    List<AppointmentList>.from(
        json.decode(str).map((x) => AppointmentList.fromJson(x)));

String AppointmentListToJson(List<AppointmentList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppointmentList {
  AppointmentList({
    this.id,
    this.specialty,
    this.doctorphone,
    this.doctorname,
    this.userid,
    this.date,
    this.checked,
    this.rappel,
  });
  AppointmentList.f(String idd, String specialtyd, String doctornamee,
      bool checkedd, bool rappeld, String useridd) {
    this.id = idd;
    this.specialty = specialtyd;
    this.doctorphone = doctorphone;
    this.doctorname = doctornamee;
    this.userid = useridd;
    this.checked = checkedd;
    this.rappel = rappeld;
  }

  String id;
  String doctorphone;
  String specialty;
  String doctorname;
  String userid;
  DateTime date;
  bool checked;
  bool rappel;

  factory AppointmentList.fromJson(Map<String, dynamic> json) =>
      AppointmentList(
        id: json["_id"],
        doctorphone: json["doctorphone"],
        specialty: json["specialty"],
        doctorname: json["doctorname"],
        userid: json["userid"],
        date: DateTime.parse(json["date"]),
        checked: json["checked"],
        rappel: json["rappel"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "doctorphone": doctorphone,
        "specialty": specialty,
        "doctorname": doctorname,
        "date": date,
        "checked": checked,
        "rappel": rappel,
        "userid": userid,
      };
}
