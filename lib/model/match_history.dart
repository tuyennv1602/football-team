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
  int countJoined;

  MatchHistory(
      {this.id,
      this.status,
      this.createDate,
      this.sendGroupScore,
      this.sendGroupPoint,
      this.receiveGroupScore,
      this.receiveGroupPoint,
      this.countConfirmed,
      this.isConfirmed,
      this.countJoined});

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
    countConfirmed = json['count_confirmed'];
    countJoined = json['count_joined'];
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

  bool get isAbleConfirm => DateUtil.isAbleConfirm(createDate);

  String get getStatusName {
    if (isUpdated && isConfirmed) {
      return 'Đã xác nhận';
    } else {
      if (!isAbleConfirm) {
        return 'Không được cập nhật';
      } else if (!isUpdated) {
        return 'Chưa cập nhật';
      } else {
        return 'Chờ xác nhận';
      }
    }
  }

  Status get getStatus {
    if (isUpdated && isConfirmed) {
      return Status.DONE;
    } else {
      if (!isAbleConfirm) {
        return Status.FAILED;
      } else if (!isUpdated) {
        return Status.NEW;
      } else {
        return Status.PENDING;
      }
    }
  }

  String get getCurrentConfirm => '$countConfirmed/$countJoined';

  double get getRatePercent =>
      countJoined > 0 ? countConfirmed / countJoined : 0;

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
