import 'package:timeago/timeago.dart';

class ViMessage implements LookupMessages {
  @override
  String aDay(int hours) => '1 ngày';

  @override
  String aboutAMinute(int minutes) => '1 phút';

  @override
  String aboutAMonth(int days) => '1 tháng';

  @override
  String aboutAYear(int year) => '1 năm';

  @override
  String aboutAnHour(int minutes) => '1 giờ';

  @override
  String days(int days) => '$days ngày';

  @override
  String hours(int hours) => '$hours giờ';

  @override
  String lessThanOneMinute(int seconds) => 'vừa xong';

  @override
  String minutes(int minutes) => '$minutes phút';

  @override
  String months(int months) => '$months tháng';

  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => 'trước';

  @override
  String suffixFromNow() => '';

  @override
  String wordSeparator() => ' ';

  @override
  String years(int years) => '$years năm trước';
}
