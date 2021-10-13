class Appointment {
  String specialty;
  String doctorphone;
  DateTime date;
  String doctorname;
  String userid;
  bool checked;
  bool rappel;
  Appointment(this.doctorname, this.specialty, this.doctorphone, this.checked,
      this.rappel, this.userid);
  Appointment.f(this.doctorphone, this.userid);
  Appointment.f2(this.doctorphone, this.doctorname, this.userid);

  Appointment.fromJson(Map<String, dynamic> json) {
    doctorname = json['doctorname'];
    specialty = json['specialty'];
    doctorphone = json['doctorphone'];
    date = json['date'];
    checked = json['checked'];
    userid = json['userid'];
    rappel = json['rappel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorname'] = this.doctorname;
    data['specialty'] = this.specialty;
    data['doctorphone'] = this.doctorphone;
    data['date'] = this.date;
    data['userid'] = this.userid;
    data['checked'] = this.checked;
    data['rappel'] = this.rappel;
    return data;
  }
}
