import 'package:intl/intl.dart';
import 'package:myfootball/utils/constants.dart';

class StringUtil {
  static String formatCurrency(double price) {
    final formatter = new NumberFormat("###,###.###", "vi");
    return '${formatter.format(price)}đ';
  }

  static int getIdFromString(String id) {
    id = id.replaceAll(',', '');
    return int.parse(id);
  }

  static String getFieldType(int type) {
    switch (type) {
      case Constants.VS5:
        return '5vs5';
      case Constants.VS7:
        return '7vs7';
      case Constants.VS9:
        return '9vs9';
      case Constants.VS11:
        return '11vs11';
      default:
        return 'Hỗ hợp';
    }
  }
}
