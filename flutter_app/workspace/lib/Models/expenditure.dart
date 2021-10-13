class Expenditure {
  String activityname;
  String activityid;
  DateTime date;
  double caloriesburned;
  double duration;
  String userid;
  Expenditure(this.activityname, this.activityid, this.date,
      this.caloriesburned, this.duration, this.userid);
  Expenditure.f(this.activityname, this.activityid, this.userid);
  Expenditure.fromJson(Map<String, dynamic> json) {
    activityname = json['activityname'];
    activityid = json['activityid'];
    date = json['date'];
    duration = json['duration'];
    caloriesburned = json['caloriesburned'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityname'] = this.activityname;
    data['activityid'] = this.activityid;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['userid'] = this.userid;
    data['caloriesburned'] = this.caloriesburned;
    return data;
  }
}
