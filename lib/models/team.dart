class Team {
  int id;
  int status;
  int manager;
  int captain;
  String name;
  String dress;
  String bio;
  String logo;
  int countMember;
  int countRequest;
  double wallet;

  Team({this.manager, this.name, this.logo, this.dress, this.bio});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    manager = json['manager'];
    captain = json['captain'];
    name = json['name'];
    logo = json['logo'];
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
    data['manager'] = this.manager;
    data['captain'] = this.captain;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['dress'] = this.dress;
    data['bio'] = this.bio;
    data['countMember'] = this.countMember;
    data['countRequest'] = this.countRequest;
    data['wallet'] = this.wallet;
    return data;
  }
}
