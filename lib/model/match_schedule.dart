import 'package:intl/intl.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/date_util.dart';

class MatchSchedule {
  String ratio;
  bool joined;
  int ticketId;
  int playDate;
  double startTime;
  double endTime;
  Team sendTeam;
  Team receiveTeam;
  String groundName;
  int groundId;
  bool isJoined;
  int matchId;
  int teamId;

  MatchSchedule(
      {this.ratio,
      this.joined,
      this.ticketId,
      this.playDate,
      this.startTime,
      this.endTime,
      this.sendTeam,
      this.receiveTeam,
      this.groundName,
      this.groundId,
      this.isJoined,
      this.matchId});

  MatchSchedule.fromJson(int teamId, Map<String, dynamic> json) {
    ratio = json['ratio'];
    joined = json['joined'];
    ticketId = json['ticket_id'];
    playDate = json['play_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    sendTeam = json['send_group'] != null
        ? new Team.fromJson(json['send_group'])
        : null;
    receiveTeam = json['receive_group'] != null
        ? new Team.fromJson(json['receive_group'])
        : null;
    groundName = json['ground_name'];
    groundId = json['ground_id'];
    isJoined = json['is_joined'];
    matchId = json['match_id'];
    this.teamId = teamId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ratio'] = this.ratio;
    data['joined'] = this.joined;
    data['ticket_id'] = this.ticketId;
    data['play_date'] = this.playDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.sendTeam != null) {
      data['send_group'] = this.sendTeam.toJson();
    }
    if (this.receiveTeam != null) {
      data['receive_group'] = this.receiveTeam.toJson();
    }
    data['ground_name'] = this.groundName;
    data['ground_id'] = this.groundId;
    data['is_joined'] = this.isJoined;
    data['match_id'] = this.matchId;
    return data;
  }

  bool get isSender => teamId == sendTeam.id;

  String get getShortPlayTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} ${DateFormat('dd/MM').format(DateTime.fromMillisecondsSinceEpoch(playDate))}';

  String get getFullPlayTime =>
      '${startTime != null ? DateUtil.getTimeStringFromDouble(startTime) : ''} ${DateUtil.getDateFromTimestamp(playDate)}';

  String get getOpponentLogo => isSender ? receiveTeam.logo : sendTeam.logo;

  String get getOpponentName => isSender ? receiveTeam.name : sendTeam.name;

  Team get getOpponentTeam => isSender ? receiveTeam : sendTeam;

  String get getMyTeamLogo => isSender ? sendTeam.logo : receiveTeam.logo;

  String get getMyTeamName => isSender ? sendTeam.name : receiveTeam.name;

  Team get getMyTeam => isSender ? sendTeam : receiveTeam;

  String get getRatio {
    if (ratio == null) return null;
    int _ratio = int.parse(ratio);
    if (_ratio == Constants.RATIO_0_100) return '0-100';
    if (_ratio == Constants.RATIO_20_80) return '20-80';
    if (_ratio == Constants.RATIO_30_70) return '30-70';
    if (_ratio == Constants.RATIO_40_60) return '40-60';
    if (_ratio == Constants.RATIO_50_50) return '50-50';
    return null;
  }
}
