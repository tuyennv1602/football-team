import 'package:timeago/timeago.dart';

class ViMessage implements LookupMessages {
  @override
  String aDay(int hours) => '1 ngày trước';

  @override
  String aboutAMinute(int minutes) => '1 phút trước';

  @override
  String aboutAMonth(int days) => '1 tháng trước';

  @override
  String aboutAYear(int year) => '1 năm trước';

  @override
  String aboutAnHour(int minutes) => '1 giờ trước';

  @override
  String days(int days) => '$days ngày trước';

  @override
  String hours(int hours) => '$hours giờ trước';

  @override
  String lessThanOneMinute(int seconds) => 'vừa xong';

  @override
  String minutes(int minutes) => '$minutes phút trước';

  @override
  String months(int months) => '$months tháng trước';

  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String wordSeparator() => ' ';

  @override
  String years(int years) => '$years năm trước';
}
