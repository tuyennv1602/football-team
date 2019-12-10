import 'package:myfootball/model/user.dart';
import 'package:myfootball/ui/widget/status_indicator.dart';

class FundMember extends User {
  int status;
  int requestId;

  FundMember.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['status'];
    requestId = json['request_id'];
  }

  String get getStatusName {
    if (status == 4) return 'Chờ xác nhận';
    if (status == 0) return 'Chưa đóng';
    return 'Hoàn thành';
  }

  Status get getStatus {
    if (status == 4) return Status.PENDING;
    if (status == 0) return Status.NEW;
    return Status.DONE;
  }
}
