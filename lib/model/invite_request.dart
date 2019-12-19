import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/model/status.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/router/date_util.dart';
import 'package:myfootball/utils/object_utils.dart';
import 'package:myfootball/utils/string_util.dart';

class InviteRequest {
  int id;
  int status;
  String title;
  int ratio;
  int createDate;
  int sendGroupId;
  String sendGroupName;
  String sendGroupLogo;
  int receiveGroupId;
  String receiveGroupName;
  String receiveGroupLogo;
  List<MatchingTimeSlot> matchingTimeSlots;
  List<MatchingTimeSlot> groundTimeSlots;
  int currentTeamId;
  int matchId;
  MatchSchedule matchInfo;

  InviteRequest(
      {this.id,
      this.status,
      this.title,
      this.ratio,
      this.createDate,
      this.sendGroupId,
      this.sendGroupName,
      this.sendGroupLogo,
      this.receiveGroupId,
      this.receiveGroupName,
      this.receiveGroupLogo,
      this.matchingTimeSlots,
      this.groundTimeSlots,
      this.matchId,
      this.currentTeamId,
      this.matchInfo});

  InviteRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    title = json['title'];
    ratio = json['ratio'];
    createDate = json['create_date'];
    sendGroupId = json['send_group_id'];
    sendGroupName = json['send_group_name'];
    sendGroupLogo = json['send_group_logo'];
    receiveGroupId = json['receive_group_id'];
    receiveGroupName = json['receive_group_name'];
    receiveGroupLogo = json['receive_group_logo'];
    if (json['time_slot_infos'] != null) {
      matchingTimeSlots = new List<MatchingTimeSlot>();
      json['time_slot_infos'].forEach((v) {
        matchingTimeSlots.add(new MatchingTimeSlot.fromJson(v));
      });
    }
    if (json['ground_time_slots'] != null) {
      groundTimeSlots = new List<MatchingTimeSlot>();
      json['ground_time_slots'].forEach((v) {
        groundTimeSlots.add(new MatchingTimeSlot.fromJson(v));
      });
    }
    matchId = json['match_id'];
    matchInfo = json['match_info'] != null
        ? new MatchSchedule.fromJson(currentTeamId, json['match_info'])
        : null;
  }

  Map<String, dynamic> toCreateInviteJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['ratio'] = this.ratio;
    data['send_group_id'] = this.sendGroupId;
    data['send_group_name'] = this.sendGroupName;
    data['receive_group_id'] = this.receiveGroupId;
    if (this.matchingTimeSlots != null) {
      data['time_slot_infos'] =
          this.matchingTimeSlots.map((v) => v.toSendInviteJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toCreateInviteJoinJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['ratio'] = this.ratio;
    data['send_group_id'] = this.sendGroupId;
    data['send_group_name'] = this.sendGroupName;
    data['receive_group_id'] = this.receiveGroupId;
    data['match_id'] = this.matchId;
    return data;
  }

  String get getCreateTime => DateUtil.getTimeAgo(createDate);

  bool get isOverTime {
    if (matchInfo != null) {
      return DateUtil.getDiffTime(matchInfo.startTime,
                  DateTime.fromMillisecondsSinceEpoch(matchInfo.playDate))
              .inMinutes <
          0;
    }
    return false;
  }

  String get getStatusName {
    if (status == Constants.INVITE_REJECTED) return 'Từ chối';
    if (status == Constants.INVITE_WAITING) {
      if (isOverTime) return 'Quá giờ';
      return 'Đang chờ';
    }
    if (status == Constants.INVITE_ACCEPTED) return 'Đã chấp nhận';
    return 'Đã huỷ';
  }

  Status get getStatus {
    if (status == Constants.INVITE_REJECTED) return Status.ABORTED;
    if (status == Constants.INVITE_WAITING) {
      if (isOverTime) return Status.ABORTED;
      return Status.PENDING;
    }
    if (status == Constants.INVITE_ACCEPTED) return Status.DONE;
    return Status.ABORTED;
  }

  Map<int, List<MatchingTimeSlot>> get getMappedTimeSlot =>
      ObjectUtil.mapMatchingTimeSlotByPlayDate(groundTimeSlots);

  int get getTypeRequest => sendGroupId == currentTeamId ? 1 : 0;

  bool get isMine => sendGroupId == currentTeamId;

  String get getLogo => isMine ? receiveGroupLogo : sendGroupLogo;

  String get getName => isMine ? receiveGroupName : sendGroupName;

  int get getId => isMine ? receiveGroupId : sendGroupId;

  String get getRatio => StringUtil.getRatioName(ratio);
}
