import 'package:myfootball/utils/date-util.dart';

class Notification {
  int id;
  String title;
  String content;
  int createTime = 1556841603000;
  int status;

  Notification({this.id, this.title, this.content, this.status});

  String get getCreateTime => DateUtil().getTimeAgo(createTime);
}
