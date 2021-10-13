import 'dart:convert';

List<SumList> SumListFromJson(String str) =>
    List<SumList>.from(json.decode(str).map((x) => SumList.fromJson(x)));

String SumListToJson(List<SumList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SumList {
  SumList({this.id, this.sum});

  String id;
  double sum;

  factory SumList.fromJson(Map<String, dynamic> json) => SumList(
        id: json["_id"],
        sum: json["sum"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sum": sum,
      };
}
