import 'package:myfootball/utils/date_util.dart';

class Notification {
  int id;
  int status;
  String title;
  String body;
  int appType;
  String result;
  int createDate;
  String deviceId;
  int contentType;
  int userId;

  Notification(
      {this.id,
      this.status,
      this.title,
      this.body,
      this.appType,
      this.result,
      this.createDate,
      this.deviceId,
      this.contentType,
      this.userId});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    title = json['title'];
    body = json['body'];
    appType = json['appType'];
    result = json['result'];
    createDate = json['create_date'];
    deviceId = json['device_id'];
    contentType = json['content_type'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['title'] = this.title;
    data['body'] = this.body;
    data['appType'] = this.appType;
    data['result'] = this.result;
    data['create_date'] = this.createDate;
    data['device_id'] = this.deviceId;
    data['content_type'] = this.contentType;
    data['user_id'] = this.userId;
    return data;
  }

  String get getCreateTime => DateUtil().getTimeAgo(createDate);
}
