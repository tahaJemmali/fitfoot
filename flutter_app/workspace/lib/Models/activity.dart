class Activity {
  String name;
  double met;
  Activity(this.name, this.met);

  Activity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    met = json['nb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['met'] = this.met;
    return data;
  }
}
