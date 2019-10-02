import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/role.dart';

class User {
  int id;
  String name;
  String userName;
  String avatar;
  String email;
  String phone;
  List<Role> roles;
  List<Team> teams;
  double wallet;

  User(
      {this.id,
      this.name,
      this.userName,
      this.avatar,
      this.email,
      this.phone,
      this.wallet});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['username'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    if (json['role_list'] != null) {
      roles = new List<Role>();
      json['role_list'].forEach((v) {
        roles.add(new Role.fromJson(v));
      });
    }
    if (json['group_list'] != null) {
      teams = new List<Team>();
      json['group_list'].forEach((v) {
        var team = new Team.fromJson(v);
        teams.add(team);
      });
    }
    if (json['wallet'] != null) {
      wallet = double.parse(json['wallet'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.userName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    if (this.roles != null) {
      data['role_list'] = this.roles.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['group_list'] = this.teams.map((v) => v.toJson()).toList();
    }
    data['wallet'] = this.wallet;
    return data;
  }

  List<Team> addTeam(Team team) {
    if (teams == null) {
      teams = [];
    }
    teams.add(team);
    return teams;
  }
}
