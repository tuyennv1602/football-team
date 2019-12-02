import 'package:myfootball/models/user.dart';

class Member extends User {
  String position;
  bool isCaptain;
  bool isManager;
  int status;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    position = json['position'];
    isCaptain = json['is_captain'];
    isManager = json['is_manager'];
    status = json['status'];
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

  String get getFundStatus {
    if (status == 4) return 'Chờ xác nhận';
    if (status == 0) return 'Chưa đóng';
    return 'Hoàn thành';
  }

  bool get isActive => status == 4;
}
