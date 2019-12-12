import 'package:myfootball/model/match_schedule.dart';

class MatchShare {
  int id;
  int status;
  String requestCode;
  int matchId;
  int groupId;
  int requestStatus;
  int matchUserId;
  MatchSchedule matchInfo;

  MatchShare(
      {this.id,
      this.status,
      this.requestCode,
      this.matchId,
      this.groupId,
      this.requestStatus,
      this.matchInfo});

  MatchShare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    requestCode = json['request_code'];
    matchId = json['match_id'];
    groupId = json['group_id'];
    requestStatus = json['request_status'];
    matchInfo = json['match_info'] != null
        ? new MatchSchedule.fromJson(groupId, json['match_info'])
        : null;
    matchUserId = json['match_user_id'];
  }

}
