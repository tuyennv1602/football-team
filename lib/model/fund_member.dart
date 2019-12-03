import 'package:myfootball/model/user.dart';

class FundMember extends User {
  int status;
  int requestId;

  FundMember.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['status'];
    requestId = json['request_id'];
  }

  String get getFundStatus {
    if (status == 4) return 'Chờ xác nhận';
    if (status == 0) return 'Chưa đóng';
    return 'Hoàn thành';
  }

  bool get isActive => status == 4;
}
