import 'package:myfootball/utils/date-util.dart';

class TeamRequest {
  String content;
  String username;
  String name;
  String avatar;
  int createDate;
  int idRequest;
  int userId;
  String position;

  TeamRequest(
      {this.content,
      this.username,
      this.name,
      this.avatar,
      this.createDate,
      this.idRequest,
      this.userId,
      this.position});

  TeamRequest.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    username = json['username'];
    name = json['name'];
    avatar = json['avatar'];
    createDate = json['createDate'];
    idRequest = json['id_request'];
    userId = json['user_id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['username'] = this.username;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['createDate'] = this.createDate;
    data['id_request'] = this.idRequest;
    data['user_id'] = this.userId;
    data['position'] = this.position;
    return data;
  }

  String get getCreateDate => DateUtil().getDateFromTimestamp(createDate);

  List<String> get getPositions => position != null ? position.split(',') : [];
}
