import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateUtil {
  static final DateUtil _instance = DateUtil.internal();

  factory DateUtil() => _instance;

  DateUtil.internal();

  String getDayOfWeek(int number) {
    switch (number) {
      case 1:
        return 'Thứ hai';
      case 2:
        return 'Thứ ba';
      case 3:
        return 'Thứ tư';
      case 4:
        return 'Thứ năm';
      case 5:
        return 'Thứ sáu';
      case 6:
        return 'Thứ bảy';
      case 7:
        return 'Chủ nhật';
    }
    return null;
  }

  String getShortDayOfWeek(int number) {
    switch (number) {
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      case 7:
        return 'CN';
    }
    return null;
  }

  String getDateFromTimestamp(int timestamp) {
    return DateFormat('dd-MM-yyyy')
        .format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  String formatDate(DateTime date, DateFormat format) {
    return format.format(date);
  }

  String getTimeAgo(int timestamp) {
    return timeago.format(new DateTime.fromMillisecondsSinceEpoch(timestamp),
        locale: 'vi');
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);
    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}
