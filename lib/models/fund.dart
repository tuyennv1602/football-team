import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';

class Fund {
  int id;
  double price;
  String title;
  int status;
  int groupId;
  int expireDate;
  int createDate;
  int userId;

  Fund(
      {this.id,
      this.price,
      this.title,
      this.status,
      this.groupId,
      this.expireDate,
      this.createDate,
      this.userId});

  Fund.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    title = json['title'];
    status = json['status'];
    groupId = json['group_id'];
    expireDate = json['expire_date'];
    createDate = json['create_date'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['title'] = this.title;
    data['status'] = this.status;
    data['group_id'] = this.groupId;
    data['expire_date'] = this.expireDate;
    data['create_date'] = this.createDate;
    data['user_id'] = this.userId;
    return data;
  }

  String get getPrice => StringUtil.formatCurrency(price);

  String get getExpiredDate => DateUtil.getDateFromTimestamp(expireDate);

  String get getStatus {
    if (status == 0) return 'Chưa đóng';
    if (status == 4) return 'Chờ xác nhận';
    return 'Đã đóng';
  }

  Color get getStatusColor {
    if (status == 0) return Colors.grey;
    if (status == 4) return Colors.amber;
    return GREEN_TEXT;
  }

  int get getStep {
    if (status == 0) return 1;
    if (status == 4) return 2;
    return 3;
  }
}