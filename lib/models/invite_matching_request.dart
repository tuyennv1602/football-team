import 'package:myfootball/models/matching_time_slot.dart';

class InviteMatchingRequest {
  int id;
  int status;
  String title;
  int ratio;
  int sendGroupId;
  int receiveGroupId;
  int createDate;
  List<MatchingTimeSlot> matchingTimeSlots;
  List<MatchingTimeSlot> groundTimeSlots;

  InviteMatchingRequest(
      {this.id,
      this.status,
      this.title,
      this.ratio,
      this.createDate,
      this.sendGroupId,
      this.receiveGroupId,
      this.matchingTimeSlots,
      this.groundTimeSlots});

  InviteMatchingRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    title = json['title'];
    ratio = json['ratio'];
    createDate = json['create_date'];
    sendGroupId = json['send_group_id'];
    receiveGroupId = json['receive_group_id'];
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
    data['receive_group_id'] = this.receiveGroupId;
    if (this.matchingTimeSlots != null) {
      data['time_slot_infos'] =
          this.matchingTimeSlots.map((v) => v.toSendInviteJson()).toList();
    }
    return data;
  }
}
