class Ward {
  String id;
  String name;
  String princeId;
  String districtId;

  Ward(
      {this.id,
      this.name,
      this.princeId,
      this.districtId});

  Ward.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    princeId = json['prince_id'].toString();
    districtId = json['district_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['prince_id'] = this.princeId;
    data['district_id'] = this.districtId;
    return data;
  }
}
