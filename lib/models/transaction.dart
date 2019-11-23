import 'package:myfootball/utils/date_util.dart';

enum TRANSACTION_TYPE { IN, OUT }

class Transaction {
  int id;
  String content;
  double price;
  int type;
  int createDate;

  Transaction(
      {this.id,
      this.content,
      this.price,
      this.type,
      this.createDate = 1571393245000});

  String get getCreateTime => DateUtil.getDateFromTimestamp(createDate);

  TRANSACTION_TYPE get getType =>
      type == 0 ? TRANSACTION_TYPE.IN : TRANSACTION_TYPE.OUT;
}
