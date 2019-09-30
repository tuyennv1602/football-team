import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/user.dart';

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
  int userId;
  List<Member> members;
  double rating;
  bool rated;

  Team({this.manager, this.name, this.logo, this.dress, this.bio, this.userId});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    manager = json['manager'];
    captain = json['captain'];
    name = json['name'];
    logo = json['logo'];
    dress = json['dress'];
    bio = json['bio'];
    if (json['rating'] != null) {
      rating = double.parse(json['rating'].toString());
    }
    rated = json['rated'];
    countMember = json['count_member'];
    countRequest = json['count_request'];
    if (json['wallet'] != null) {
      wallet = double.parse(json['wallet'].toString());
    }
    if (json['users'] != null) {
      members = new List<Member>();
      json['users'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
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
    data['count_member'] = this.countMember;
    data['count_request'] = this.countRequest;
    data['wallet'] = this.wallet;
    data['rating'] = this.rating;
    data['rated'] = this.rated;
    if (this.members != null) {
      data['users'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool get isManager => manager == userId;

  bool get isCaptain => captain == userId;
}
