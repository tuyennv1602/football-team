import 'package:myfootball/router/date_util.dart';

class Comment {
  int id;
  int status;
  double rating;
  int type;
  String comment;
  int createDate;
  int userId;
  String userName;
  String userAvatar;
  int targetId;

  Comment(
      {this.id,
      this.status,
      this.rating,
      this.type,
      this.comment,
      this.createDate,
      this.userId,
      this.userName,
      this.userAvatar,
      this.targetId});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    rating = json['rating'];
    type = json['type'];
    comment = json['comment'];
    createDate = json['create_date'];
    userId = json['user_id'];
    userName = json['user_name'];
    userAvatar = json['user_avatar'];
    targetId = json['target_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['rating'] = this.rating;
    data['type'] = this.type;
    data['comment'] = this.comment;
    data['create_date'] = this.createDate;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_avatar'] = this.userAvatar;
    data['target_id'] = this.targetId;
    return data;
  }

  String get getCreateTime => DateUtil.getTimeAgo(createDate);

}
