import 'package:myfootball/utils/date_util.dart';

class TimeSlot {
  int id;
  int status;
  int duration;
  double price;
  int fieldId;
  double startTime;
  double endTime;
  int dayOfWeek;

  TimeSlot(
      {this.id,
      this.status,
      this.duration,
      this.price,
      this.fieldId,
      this.startTime,
      this.endTime,
      this.dayOfWeek});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    duration = json['duration'];
    price = json['price'];
    fieldId = json['field_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    dayOfWeek = json['day_of_week'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['field_id'] = this.fieldId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['day_of_week'] = this.dayOfWeek;
    return data;
  }

  String get getTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} - ${DateUtil.getTimeStringFromDouble(endTime)}';
}
