import 'package:myfootball/router/date_util.dart';
import 'package:myfootball/utils/string_util.dart';

enum TRANSACTION_TYPE { IN, OUT }

class Transaction {
  int id;
  double price;
  String title;
  int type;
  String userName;
  int createDate;

  Transaction(
      {this.id,
        this.price,
        this.title,
        this.type,
        this.userName,
        this.createDate});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    title = json['title'];
    type = json['type'];
    userName = json['user_name'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['title'] = this.title;
    data['type'] = this.type;
    data['user_name'] = this.userName;
    data['create_date'] = this.createDate;
    return data;
  }

  String get getCreateTime => DateUtil.getDateFromTimestamp(createDate);

  TRANSACTION_TYPE get getType =>
      type == 1 ? TRANSACTION_TYPE.IN : TRANSACTION_TYPE.OUT;

  String get getPrice => StringUtil.formatCurrency(price);
}
