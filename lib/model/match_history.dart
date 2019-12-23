import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/status.dart';
import 'package:myfootball/utils/date_util.dart';

class MatchHistory extends MatchSchedule {
  int id;
  int status;
  int createDate;
  int sendGroupScore;
  double sendGroupPoint;
  int receiveGroupScore;
  double receiveGroupPoint;
  bool isJoined;
  bool isConfirmed;
  int countConfirmed;
  int countJoined;
  bool userConfirmed;

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
      this.countJoined,
      this.isJoined,
      this.userConfirmed});

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
    isJoined = json['is_joined'];
    userConfirmed = json['user_confirmed'];
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

  void updatePoint(double point) {
    if (isSender) {
      sendGroupPoint = point;
    } else {
      receiveGroupPoint = point;
    }
  }

  String get getStatusName {
    if(!hasOpponentTeam) return 'Tập luyện';
    if (isUpdated && isConfirmed) {
      return 'Đã xác nhận';
    } else {
      if (!isAbleConfirm) {
        return 'Không cập nhật';
      } else if (!isUpdated) {
        return 'Chờ cập nhật';
      } else {
        return 'Chờ xác nhận';
      }
    }
  }

  Status get getStatus {
    if(!hasOpponentTeam) return Status.ABORTED;
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

  String get getBonus {
    if (getMyTeamPoint == null) return '0';
    var myPoint = getMyTeamPoint > 0 ? getMyTeamPoint : (-1 * getMyTeamPoint);
    if (getRatePercent >= 0.3 && getRatePercent < 0.5)
      return (myPoint * 0.05).toStringAsFixed(2);
    if (getRatePercent >= 0.5 && getRatePercent < 0.8)
      return (myPoint * 0.1).toStringAsFixed(2);
    if (getRatePercent >= 0.8) return (myPoint * 0.15).toStringAsFixed(2);
    return '0';
  }
}
