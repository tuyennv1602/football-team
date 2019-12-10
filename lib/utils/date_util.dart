import 'package:intl/intl.dart';
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

  static DateTime fromTimeStamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp);

  static String getDateFromTimestamp(int timestamp) =>
      DateFormat('dd/MM/yyyy').format(fromTimeStamp(timestamp));

  static String getTimeAgo(int timestamp) =>
      timeago.format(fromTimeStamp(timestamp), locale: 'vi');

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

  static int getDateTimeStamp(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day)
          .millisecondsSinceEpoch;

  static String getMinuteString(double decimalValue) =>
      '${(decimalValue * 60).toInt()}'.padLeft(2, '0');

  static String getHourString(int flooredValue) =>
      '${flooredValue % 24}'.padLeft(2, '0');

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

  static Duration getDiffTime(double time, DateTime playDate) {
    DateTime _now = DateTime.now();
    List<int> _time = getTimeFromDouble(time);
    if (_time == null) return null;
    DateTime _timeSlot = DateTime(
        playDate.year, playDate.month, playDate.day, _time[0], _time[1]);
    return _timeSlot.difference(_now);
  }

  static bool isAbleBooking(double startTime, DateTime playDate) =>
      getDiffTime(startTime, playDate).inMinutes > 0;

  static bool isOverTimeCancel(double startTime, int playDate) =>
      getDiffTime(startTime, fromTimeStamp(playDate)).inDays < 1;

  static bool isAbleConfirm(int createTime) =>
      DateTime.now().difference(fromTimeStamp(createTime)).inDays < 1;

  static bool isExpired(int expireTime) =>
      fromTimeStamp(expireTime).difference(DateTime.now()).inDays < 0;

  static String formatMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  DateTime parseDateRss(String date) =>
      DateFormat('EEE, dd MMM yyyy hh:mm:ss zzz').parse(date);
}
