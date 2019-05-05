class Group {
  int id;
  int status;
  int createDate;
  int manager;
  Null captain;
  String name;
  String dress;
  String bio;
  int countMember;
  int countRequest;
  double wallet;

  Group(
      {this.id,
      this.status,
      this.createDate,
      this.manager,
      this.captain,
      this.name,
      this.dress,
      this.bio,
      this.countMember,
      this.countRequest,
      this.wallet});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createDate = json['createDate'];
    manager = json['manager'];
    captain = json['captain'];
    name = json['name'];
    dress = json['dress'];
    bio = json['bio'];
    countMember = json['countMember'];
    countRequest = json['countRequest'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['manager'] = this.manager;
    data['captain'] = this.captain;
    data['name'] = this.name;
    data['dress'] = this.dress;
    data['bio'] = this.bio;
    data['countMember'] = this.countMember;
    data['countRequest'] = this.countRequest;
    data['wallet'] = this.wallet;
    return data;
  }
}
