class Routine {
  String userid;
  String medid;
  String medname;
  Routine(this.medname, this.userid, this.medid);
  Routine.f(this.medid, this.medname, this.userid);

  Routine.fromJson(Map<String, dynamic> json) {
    medname = json['medname'];
    userid = json['userid'];
    medid = json['medid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medname'] = this.medname;
    data['userid'] = this.userid;
    data['medid'] = this.medid;
    return data;
  }
}
