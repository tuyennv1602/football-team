import 'package:intl/intl.dart';

class StringUtil {
  static String formatCurrency(double price) {
    final formatter = new NumberFormat("###,###.###", "vi");
    return '${formatter.format(price)}đ';
  }
}
