class Med {
  String name;
  String type;
  int nb;
  Med(this.name, this.type, this.nb);

  Med.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    nb = json['nb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nb'] = this.nb;
    return data;
  }
}
