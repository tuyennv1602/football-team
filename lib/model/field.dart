import 'package:myfootball/model/time_slot.dart';
import 'package:myfootball/utils/string_util.dart';

class Field {
  int id;
  int status;
  String name;
  int type;
  int tickets;
  int groundId;
  List<TimeSlot> timeSlots;

  Field(
      {this.id,
        this.status,
        this.name,
        this.type,
        this.tickets,
        this.groundId,
        this.timeSlots});

  Field.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    name = json['name'];
    type = json['type'];
    tickets = json['tickets'];
    groundId = json['ground_id'];
    if (json['time_slots'] != null) {
      timeSlots = new List<TimeSlot>();
      json['time_slots'].forEach((v) {
        timeSlots.add(new TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['name'] = this.name;
    data['type'] = this.type;
    data['tickets'] = this.tickets;
    data['ground_id'] = this.groundId;
    if (this.timeSlots != null) {
      data['time_slots'] = this.timeSlots.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get getFieldType => StringUtil.getFieldType(type);
}