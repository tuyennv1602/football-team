import 'package:intl/intl.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/utils/date_util.dart';

class MatchSchedule {
  int ticketId;
  int playDate;
  double startTime;
  double endTime;
  Team sendTeam;
  int teamId;
  Team receiveTeam;

  MatchSchedule(
      {this.ticketId,
      this.playDate,
      this.startTime,
      this.endTime,
      this.sendTeam,
      this.receiveTeam});

  MatchSchedule.fromJson(int teamId, Map<String, dynamic> json) {
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
    this.teamId = teamId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }

  bool get isSender => teamId == sendTeam.id;

  String get getShortPlayTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} ${DateFormat('dd/MM').format(DateTime.fromMillisecondsSinceEpoch(playDate))}';

  String get getFullPlayTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} ${DateUtil.getDateFromTimestamp(playDate)}';

  String get getOpponentLogo => isSender ? receiveTeam.logo : sendTeam.logo;

  String get getOpponentName => isSender ? receiveTeam.name : sendTeam.name;

  Team get getOpponentTeam => isSender ? receiveTeam : sendTeam;
}
