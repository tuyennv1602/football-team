class Role {
  int id;
  int status;
  int createDate;
  int code;
  String name;

  Role({this.id, this.status, this.createDate, this.code, this.name});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createDate = json['create_date'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
