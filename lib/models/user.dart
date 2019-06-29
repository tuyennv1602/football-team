import 'package:myfootball/models/group.dart';
import 'package:myfootball/models/role.dart';
import 'package:myfootball/models/type-user.dart';
import 'package:myfootball/res/constants.dart';

class User {
  int id;
  String userName;
  String avatar;
  String email;
  String phone;
  List<Role> roles;
  List<Group> groups;
  double wallet;

  User(
      {this.id,
      this.userName,
      this.avatar,
      this.email,
      this.phone,
      this.roles,
      this.groups,
      this.wallet});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    if (json['roleList'] != null) {
      roles = new List<Role>();
      json['roleList'].forEach((v) {
        roles.add(new Role.fromJson(v));
      });
    }
    if (json['groupList'] != null) {
      groups = new List<Group>();
      json['groupList'].forEach((v) {
        groups.add(new Group.fromJson(v));
      });
    }
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    if (this.roles != null) {
      data['roleList'] = this.roles.map((v) => v.toJson()).toList();
    }
    if (this.groups != null) {
      data['groupList'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['wallet'] = this.wallet;
    return data;
  }

  USER_ROLE getRoleType() {
    if (roles.length == 0) {
      return USER_ROLE.TEAM_MEMBER;
    } else if (roles.length == 1) {
      if (roles[0].code == Constants.TEAM_MANAGER) {
        return USER_ROLE.TEAM_MANAGER;
      } else {
        return USER_ROLE.GROUND_OWNER;
      }
    } else {
      return USER_ROLE.ALL;
    }
  }

  List<Group> addGroup(Group group) {
    if (groups == null) return [];
    groups.add(group);
    return groups;
  }
}
