import 'package:intl/intl.dart';

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

  String formatDateTimestamp(int timestamp, DateFormat format) {
    return format
        .format(new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  String formatDateTime(DateTime date, DateFormat format) {
    return format.format(date);
  }

  DateTime parseDateRss(String date) {
    return DateFormat('EEE, dd MMM yyyy hh:mm:ss zzz').parse(date);
  }

}
