class Contact {
  String name;
  String phone;
  String type;
  String specialty;
  String userid;
  Contact(this.name, this.phone, this.userid, this.type);
  Contact.f(this.name, this.phone, this.type, this.specialty, this.userid);
  Contact.f2(this.name, this.phone, this.type, this.userid);

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    type = json['contacttype'];
    specialty = json['specialty'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['contacttype'] = this.type;
    data['specialty'] = this.specialty;
    data['userid'] = this.userid;
    return data;
  }
}
