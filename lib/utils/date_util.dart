import 'package:intl/intl.dart';
import 'package:myfootball/models/time_slot.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateUtil {
  static String getDayOfWeek(int number) {
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

  static String getShortDayOfWeek(int number) {
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

  static String getDateFromTimestamp(int timestamp) {
    return DateFormat('dd/MM/yyyy')
        .format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static String formatDate(DateTime date, DateFormat format) {
    return format.format(date);
  }

  static String getTimeAgo(int timestamp) {
    return timeago.format(new DateTime.fromMillisecondsSinceEpoch(timestamp),
        locale: 'vi');
  }

  static String getTimeStringFromDouble(double value) {
    if (value < 0) return null;
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);
    return '$hourValue:$minuteString';
  }

  static List<int> getTimeFromDouble(double value) {
    if (value < 0) return null;
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);
    return [int.parse(hourValue), int.parse(minuteString)];
  }

  static int getDateTimeStamp(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
  }

  static String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  static String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  static DateTime getDateMatching(int dayOfWeek) {
    DateTime date = DateTime.now();
    int _weekDay = date.weekday;
    if (_weekDay < dayOfWeek) {
      return date.add(Duration(days: dayOfWeek - _weekDay));
    } else if (_weekDay > dayOfWeek) {
      return date.add(Duration(days: 7 - _weekDay + dayOfWeek));
    } else {
      return date;
    }
  }

  static bool isAbleBooking(DateTime playDate, TimeSlot timeSlot) {
    DateTime _now = DateTime.now();
    List<int> _time = getTimeFromDouble(timeSlot.startTime);
    if (_time == null) return false;
    DateTime _timeSlot = DateTime(
        playDate.year, playDate.month, playDate.day, _time[0], _time[1]);
    Duration difference = _timeSlot.difference(_now);
    return difference.inMinutes > 0;
  }
}
