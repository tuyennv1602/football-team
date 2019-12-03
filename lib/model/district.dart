class District {
  String id;
  String name;
  String princeId;

  District({this.id, this.name, this.princeId});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    princeId = json['prince_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['prince_id'] = this.princeId;
    return data;
  }
}
