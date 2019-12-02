import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/currency_formatter.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

// ignore: must_be_immutable
class InputPriceWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final String hint;
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  Timer _debounce;

  InputPriceWidget(
      {Key key,
      this.keyword = '',
      this.hint,
      @required this.onChangedText,
      this.textStyle,
      this.hintTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = this.keyword.length;
    return TextField(
      cursorColor: PRIMARY,
      cursorWidth: 1,
      onChanged: (text) {
        if (_debounce?.isActive ?? false) _debounce.cancel();
        _debounce =
            Timer(const Duration(milliseconds: 500), () => onChangedText(text));
      },
      autocorrect: false,
      keyboardType: TextInputType.number,
      style: textStyle ?? textStyleMediumTitle(),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        CurrencyFormatter()
      ],
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintTextStyle ?? textStyleMediumTitle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero),
      textInputAction: TextInputAction.done,
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: this.keyword,
          selection: TextSelection.collapsed(offset: length - 1),
        ),
      ),
    );
  }
}
