import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/date_util.dart';

class UserRequest {
  String content;
  int status;
  int createDate;
  int idRequest;
  int idTeam;
  String teamName;
  String teamLogo;
  String position;

  UserRequest(
      {this.content,
      this.status,
      this.createDate,
      this.idRequest,
      this.idTeam,
      this.teamName,
      this.teamLogo,
      this.position});

  UserRequest.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    status = json['status'];
    createDate = json['createDate'];
    idRequest = json['id_request'];
    idTeam = json['id_team'];
    teamName = json['team_name'];
    teamLogo = json['team_logo'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.idRequest;
    data['content'] = this.content;
    data['group_id'] = this.idTeam;
    data['position'] = this.position;
    return data;
  }

  String get getCreateDate => DateUtil.getDateFromTimestamp(createDate);

  String get getStatus {
    if (status == Constants.REQUEST_WAITING) return 'Đang chờ';
    if (status == Constants.REQUEST_CANCEL) return 'Đã huỷ';
    if (status == Constants.REQUEST_ACCEPTED) return 'Đã chấp nhận';
    if (status == Constants.REQUEST_REJECTED) return 'Đã từ chối';
    return 'Không xác định';
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

  Color get getStatusColor {
    if (status == Constants.REQUEST_WAITING) return GREEN_TEXT;
    return Colors.grey;
  }
}
