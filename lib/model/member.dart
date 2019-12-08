import 'package:myfootball/model/user.dart';

class Member extends User {
  String position;
  bool isCaptain;
  bool isManager;
  int userId;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    position = json['position'];
    isCaptain = json['is_captain'];
    isManager = json['is_manager'];
    userId = json['user_id'];
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

}
