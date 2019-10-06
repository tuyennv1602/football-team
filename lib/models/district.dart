class District {
  int id;
  int status;
  String code;
  String name;
  Null createDate;
  Null createUser;
  int princeId;

  District(
      {this.id,
        this.status,
        this.code,
        this.name,
        this.createDate,
        this.createUser,
        this.princeId});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    code = json['code'];
    name = json['name'];
    createDate = json['create_date'];
    createUser = json['create_user'];
    princeId = json['prince_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['code'] = this.code;
    data['name'] = this.name;
    data['create_date'] = this.createDate;
    data['create_user'] = this.createUser;
    data['prince_id'] = this.princeId;
    return data;
  }
}