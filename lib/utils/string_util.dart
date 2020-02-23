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

  static String getRatioName(int type) {
    switch (type) {
      case Constants.RATIO_50_50:
        return '50-50';
      case Constants.RATIO_40_60:
        return '40-60';
      case Constants.RATIO_30_70:
        return '30-70';
      case Constants.RATIO_20_80:
        return '20-80';
      case Constants.RATIO_0_100:
        return '0-100';
      default:
        return null;
    }
  }

  static String getTransactionName(int type) {
    switch (type) {
      case Constants.TRANSACTION_IN:
        return 'Thu';
      case Constants.TRANSACTION_OUT:
        return 'Chi';
      default:
        return null;
    }
  }

  static double getPriceFromString(String price) {
    if (price.isEmpty) return 0;
    price = price.replaceAll('.', '');
    price = price.replaceAll('đ', '');
    return double.parse(price);
  }
}
