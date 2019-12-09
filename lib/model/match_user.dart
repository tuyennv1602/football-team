import 'package:myfootball/model/user.dart';
import 'package:myfootball/ui/widget/status_indicator.dart';
import 'package:myfootball/utils/date_util.dart';

class MatchUser extends User {
  String position;
  int status;
  int matchUserId;
  int createDate;

  MatchUser.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    position = json['position'];
    status = json['status'];
    matchUserId = json['match_user_id'];
    createDate = json['create_date'];
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

  String get getCreateTime => DateUtil.getTimeAgo(createDate);
}
