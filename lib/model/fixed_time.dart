import 'package:myfootball/model/status.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';

class FixedTime {
  int id;
  int status;
  double rating;
  double price;
  int createDate;
  int timeSlotId;
  int groupId;
  int dayOfWeek;
  int groundId;
  String groundName;
  int fieldId;
  String fieldName;
  double startTime;
  double endTime;

  FixedTime(
      {this.id,
      this.status,
      this.rating,
      this.price,
      this.createDate,
      this.timeSlotId,
      this.groupId,
      this.dayOfWeek,
      this.groundId,
      this.groundName,
      this.fieldId,
      this.fieldName,
      this.startTime,
      this.endTime});

  FixedTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    rating = json['rating'];
    price = json['price'];
    createDate = json['create_date'];
    timeSlotId = json['time_slot_id'];
    groupId = json['group_id'];
    dayOfWeek = json['day_of_week'];
    groundId = json['ground_id'];
    groundName = json['ground_name'];
    fieldId = json['field_id'];
    fieldName = json['field_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  String get getStatusName {
    if (status == 4) return 'Chờ xác nhận';
    return 'Đang hoạt động';
  }

  Status get getStatus {
    if (status == 4) return Status.PENDING;
    return Status.DONE;
  }

  String get getCreateTime => DateUtil.getTimeAgo(createDate);

  String get getFullPlayTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} - ${DateUtil.getTimeStringFromDouble(endTime)}  ${DateUtil.getDayOfWeek(dayOfWeek)} hàng tuần';

  String get getPrice => StringUtil.formatCurrency(price);
}
