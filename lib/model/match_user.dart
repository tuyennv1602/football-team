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

  Map<String, dynamic> toMemberJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.userName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['position'] = this.position;
    data['is_captain'] = false;
    data['is_manager'] = false;
    return data;
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
