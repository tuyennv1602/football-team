import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/ui/widget/status_indicator.dart';
import 'package:myfootball/utils/date_util.dart';

class MatchHistory extends MatchSchedule {
  int id;
  int status;
  int createDate;
  int sendGroupScore;
  double sendGroupPoint;
  int receiveGroupScore;
  double receiveGroupPoint;
  bool isConfirmed;
  int countConfirmed;

  MatchHistory(
      {this.id,
      this.status,
      this.createDate,
      this.sendGroupScore,
      this.sendGroupPoint,
      this.receiveGroupScore,
      this.receiveGroupPoint,
      this.countConfirmed,
      this.isConfirmed});

  MatchHistory.fromJson(int teamId, Map<String, dynamic> json)
      : super.fromJson(teamId, json) {
    id = json['id'];
    status = json['status'];
    createDate = json['create_date'];
    sendGroupScore = json['send_group_score'];
    sendGroupPoint = json['send_group_point'];
    receiveGroupScore = json['receive_group_score'];
    receiveGroupPoint = json['receive_group_point'];
    isConfirmed = json['is_confirmed'];
    countConfirmed = json['count_confirm'];
  }

  String get getPlayTime => '${DateUtil.getDateFromTimestamp(playDate)}';

  String get getSendTeamScore =>
      sendGroupScore != null ? sendGroupScore.toString() : '';

  String get getReceiveTeamScore =>
      receiveGroupScore != null ? receiveGroupScore.toString() : '';

  String get getMyTeamScore =>
      isSender ? getSendTeamScore : getReceiveTeamScore;

  String get getOpponentTeamScore =>
      isSender ? getReceiveTeamScore : getSendTeamScore;

  double get getMyTeamPoint => isSender ? sendGroupPoint : receiveGroupPoint;

  double get getOpponentTeamPoint =>
      isSender ? receiveGroupPoint : sendGroupPoint;

  bool get isUpdated => sendGroupScore != null && receiveGroupScore != null;

  String get getStatusName {
    if (!isUpdated) {
      return 'Chưa cập nhật';
    }
    if (!isConfirmed) {
      return 'Chờ xác nhận';
    }
    return 'Đã xác nhận';
  }

  Status get getStatus {
    if (!isUpdated) {
      return Status.NEW;
    }
    if (!isConfirmed) {
      return Status.PENDING;
    }
    return Status.DONE;
  }

  double get getRatePercent => 0.4;

  Color get getRateColor {
    if (getRatePercent >= 0.3 && getRatePercent < 0.5) return Colors.green;
    if (getRatePercent >= 0.5 && getRatePercent < 0.8) return Colors.amber;
    if (getRatePercent >= 0.8) return Colors.deepPurpleAccent;
    return Colors.grey;
  }

  double get getBonus {
    if (getMyTeamPoint == null) return 0;
    var myPoint = getMyTeamPoint > 0 ? getMyTeamPoint : (-1 * getMyTeamPoint);
    if (getRatePercent >= 0.3 && getRatePercent < 0.5) return myPoint * 0.05;
    if (getRatePercent >= 0.5 && getRatePercent < 0.8) return myPoint * 0.1;
    if (getRatePercent >= 0.8) return myPoint * 0.15;
    return 0;
  }
}
