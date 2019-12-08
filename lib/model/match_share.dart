import 'package:myfootball/model/match_schedule.dart';

class MatchShare {
  int id;
  int status;
  String requestCode;
  int matchId;
  int groupId;
  int requestStatus;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['request_code'] = this.requestCode;
    data['match_id'] = this.matchId;
    data['group_id'] = this.groupId;
    data['request_status'] = this.requestStatus;
    if (this.matchInfo != null) {
      data['match_info'] = this.matchInfo.toJson();
    }
    return data;
  }
}
