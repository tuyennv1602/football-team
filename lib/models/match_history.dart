import 'package:myfootball/models/match_schedule.dart';
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

  MatchHistory(
      {this.id,
      this.status,
      this.createDate,
      this.sendGroupScore,
      this.sendGroupPoint,
      this.receiveGroupScore,
      this.receiveGroupPoint,
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

  String get getStatus {
    if (!isUpdated) {
      return 'Chưa cập nhật';
    }
    if (!isConfirmed) {
      return 'Chờ xác nhận';
    }
    return null;
  }
}
