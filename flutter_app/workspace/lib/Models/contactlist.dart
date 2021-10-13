import 'dart:convert';

List<ContactList> ContactListFromJson(String str) => List<ContactList>.from(
    json.decode(str).map((x) => ContactList.fromJson(x)));

String ContactListToJson(List<ContactList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactList {
  ContactList({
    this.id,
    this.firstName,
    this.phone,
    this.type,
    this.specialty,
    this.userid,
  });

  String id;
  String firstName;
  String phone;
  String type;
  String specialty;
  String userid;

  factory ContactList.fromJson(Map<String, dynamic> json) => ContactList(
        id: json["_id"],
        firstName: json["firstName"],
        phone: json["phone"],
        type: json["contacttype"],
        specialty: json["specialty"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "FirstName": firstName,
        "phone": phone,
        "contacttype": type,
        "specialty": specialty,
        "userid": userid,
      };
}
