class Intake {
  String userid;
  String medid;
  DateTime date;
  String medname;
  bool checked;
  Intake(this.medname, this.userid, this.medid, this.checked);
  Intake.f(this.medid);
  Intake.f2(this.medid, this.medname, this.userid);

  Intake.fromJson(Map<String, dynamic> json) {
    medname = json['medname'];
    userid = json['userid'];
    medid = json['medid'];
    date = json['date'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medname'] = this.medname;
    data['userid'] = this.userid;
    data['medid'] = this.medid;
    data['date'] = this.date;
    data['checked'] = this.checked;
    return data;
  }
}
