import 'package:myfootball/utils/date_util.dart';

class Ticket {
  int id;
  int status;
  int type;
  int groundId;
  String groundName;
  double rating;
  int fieldId;
  String fieldName;
  double price;
  double startTime;
  double endTime;
  int createDate;
  int timeSlotId;
  int groupId;
  int playDate;
  int prepaymentStatus;
  int paymentStatus;

  Ticket(
      {this.id,
        this.status,
        this.type,
        this.groundId,
        this.groundName,
        this.rating,
        this.fieldId,
        this.fieldName,
        this.price,
        this.startTime,
        this.endTime,
        this.createDate,
        this.timeSlotId,
        this.groupId,
        this.playDate,
        this.prepaymentStatus,
        this.paymentStatus});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    type = json['type'];
    groundId = json['groundId'];
    groundName = json['groundName'];
    rating = json['rating'];
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    price = json['price'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    createDate = json['create_date'];
    timeSlotId = json['time_slot_id'];
    groupId = json['group_id'];
    playDate = json['play_date'];
    prepaymentStatus = json['prepayment_status'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['type'] = this.type;
    data['groundId'] = this.groundId;
    data['groundName'] = this.groundName;
    data['rating'] = this.rating;
    data['fieldId'] = this.fieldId;
    data['fieldName'] = this.fieldName;
    data['price'] = this.price;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['create_date'] = this.createDate;
    data['time_slot_id'] = this.timeSlotId;
    data['group_id'] = this.groupId;
    data['play_date'] = this.playDate;
    data['prepayment_status'] = this.prepaymentStatus;
    data['payment_status'] = this.paymentStatus;
    return data;
  }

  String get getFullPlayTime =>
      '${DateUtil.getTimeStringFromDouble(startTime)} - ${DateUtil.getTimeStringFromDouble(endTime)}  ${DateUtil.getDateFromTimestamp(playDate)}';

  bool get isOverTime => DateUtil.isOverTimeCancel(startTime, playDate);

}