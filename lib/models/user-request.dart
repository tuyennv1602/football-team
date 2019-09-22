import 'package:myfootball/utils/date-util.dart';

class UserRequest {
  String content;
  int status;
  int createDate;
  int idRequest;
  int idName;
  String teamName;
  String teamLogo;

  UserRequest(
      {this.content,
      this.status,
      this.createDate,
      this.idRequest,
      this.idName,
      this.teamName,
      this.teamLogo});

  UserRequest.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    status = json['status'];
    createDate = json['createDate'];
    idRequest = json['id_request'];
    idName = json['id_name'];
    teamName = json['team_name'];
    teamLogo = json['team_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['id_request'] = this.idRequest;
    data['id_name'] = this.idName;
    data['team_name'] = this.teamName;
    data['team_logo'] = this.teamLogo;
    return data;
  }

  String get getCreateDate => DateUtil().getDateFromTimestamp(createDate);
}
