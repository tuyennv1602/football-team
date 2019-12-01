import 'package:myfootball/models/user.dart';

class Member extends User {
  String position;
  bool isCaptain;
  bool isManager;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    position = json['position'];
    isCaptain = json['is_captain'];
    isManager = json['is_manager'];
  }

  List<String> get getPositions => position != null ? position.split(',') : [];
}
