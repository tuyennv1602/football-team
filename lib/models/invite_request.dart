import 'package:flutter/material.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/utils/date_util.dart';

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

  InviteRequest({this.id,
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
    this.groundTimeSlots});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['ratio'] = this.ratio;
    data['send_group_id'] = this.sendGroupId;
    data['send_group_name'] = this.sendGroupName;
    data['receive_group_id'] = this.receiveGroupId;
    if (this.matchingTimeSlots != null) {
      data['time_slot_infos'] =
          this.matchingTimeSlots.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
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

  String get getCreateTime => DateUtil.getTimeAgo(createDate);

  String get getStatus {
    if (status == 1) return 'Đang chờ';
    if (status == 2) return 'Đã huỷ';
    return 'Không xác định';
  }

  Color get getStatusColor {
    if (status == 1) return Colors.red;
    if (status == 2) return Colors.grey;
    return Colors.green;
  }

}
