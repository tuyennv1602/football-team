import 'package:myfootball/model/user.dart';

class Member extends User {
  String position;
  bool isCaptain;
  bool isManager;
  String number;
  int teamGame;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    position = json['position'];
    isCaptain = json['is_captain'];
    isManager = json['is_manager'];
    number = json['number'];
    teamGame = json['group_number_play'];
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

}
