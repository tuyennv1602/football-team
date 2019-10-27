import 'package:myfootball/utils/date_util.dart';

class MatchingTimeSlot {
  double price;
  int type;
  int timeSlotId;
  double startTime;
  double endTime;
  int dayOfWeek;
  int groundId;
  int playDate;
  String groundName;
  String groundAddress;

  MatchingTimeSlot(
      {this.price,
      this.type,
      this.timeSlotId,
      this.startTime,
      this.endTime,
      this.dayOfWeek,
      this.groundId,
      this.groundName,
      this.groundAddress,
      this.playDate});

  MatchingTimeSlot.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    type = json['type'];
    timeSlotId = json['time_slot_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    playDate = json['play_date'];
    dayOfWeek = json['day_of_week'];
    groundId = json['ground_id'];
    groundName = json['ground_name'];
    groundAddress = json['ground_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['type'] = this.type;
    data['time_slot_id'] = this.timeSlotId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['day_of_week'] = this.dayOfWeek;
    data['ground_id'] = this.groundId;
    data['ground_name'] = this.groundName;
    data['ground_address'] = this.groundAddress;
    return data;
  }

  Map<String, dynamic> toSendInviteJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_slot_id'] = this.timeSlotId;
    data['play_date'] =
        DateUtil().getDateTimeStamp(DateUtil().getDateMatching(dayOfWeek));
    return data;
  }

  String get getType {
    if (type == 0)
      return 'Sân trung lập';
    else if (type == 1)
      return 'Sân nhà';
    else
      return 'Sân khách';
  }
}
