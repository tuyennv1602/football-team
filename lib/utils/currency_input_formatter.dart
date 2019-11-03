import 'package:flutter/services.dart';
import 'package:myfootball/utils/string_util.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    String formattedValue =
        StringUtil.formatCurrency(double.parse(newValue.text));

    return newValue.copyWith(
        text: formattedValue,
        selection: new TextSelection.collapsed(offset: formattedValue.length - 1));
  }
}
