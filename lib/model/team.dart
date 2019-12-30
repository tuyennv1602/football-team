import 'package:myfootball/model/member.dart';

import 'group_matching_info.dart';

class Team {
  int id;
  int status;
  int managerId;
  int captainId;
  String name;
  String dress;
  String bio;
  String logo;
  int countMember;
  int countRequest;
  double wallet;
  List<Member> members;
  double rating;
  double point;
  int rank;
  int isSearching;
  List<GroupMatchingInfo> groupMatchingInfo;
  int mp;
  int win;
  String code;
  bool isVerified;
  int trustPoint;

  Team(
      {this.id,
      this.managerId,
      this.name,
      this.logo,
      this.dress,
      this.bio,
      this.rating,
      this.rank,
      this.isVerified});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    managerId = json['manager'];
    captainId = json['captain'];
    name = json['name'];
    logo = json['logo'];
    dress = json['dress'];
    bio = json['bio'];
    point = json['point'];
    rank = json['rank'];
    if (json['rating'] != null) {
      rating = double.parse(json['rating'].toString());
    }
    isVerified = json['is_verify'];
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
    isSearching = json['is_searching'];
    if (json['group_matching_infos'] != null) {
      groupMatchingInfo = new List<GroupMatchingInfo>();
      json['group_matching_infos'].forEach((v) {
        groupMatchingInfo.add(new GroupMatchingInfo.fromJson(v));
      });
    }
    mp = json['number_match'];
    win = json['number_match_win'];
    code = json['request_code'];
    trustPoint = json['trust_point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['manager'] = this.managerId;
    data['captain'] = this.captainId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['dress'] = this.dress;
    data['bio'] = this.bio;
    data['count_member'] = this.countMember;
    data['count_request'] = this.countRequest;
    data['wallet'] = this.wallet;
    data['rating'] = this.rating;
    if (this.members != null) {
      data['users'] = this.members.map((v) => v.toJson()).toList();
    }
    data['is_searching'] = this.isSearching;
    if (this.groupMatchingInfo != null) {
      data['group_matching_infos'] =
          this.groupMatchingInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> createTeamJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manager'] = this.managerId;
    data['name'] = this.name;
    data['dress'] = this.dress;
    data['bio'] = this.bio;
    return data;
  }

  bool hasManager(int userId) => userId == managerId || userId == captainId;

  String get tag => 'team-$id';

  String get getRank => rank != null ? rank.toString() : '';

  String get getPoint => point != null ? point.toStringAsFixed(2) : '';

  String get getRating => rating != null ? rating.toStringAsFixed(1) : '';

  String get getTrustPoint => trustPoint != null ? trustPoint.toString() : '';
}
