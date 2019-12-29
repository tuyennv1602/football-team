import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

// ignore: must_be_immutable
class InputScoreWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final String hint;
  Timer _debounce;

  InputScoreWidget(
      {Key key,
      this.keyword = '',
      this.hint = '0',
      @required this.onChangedText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = this.keyword.length;
    return Container(
      width: UIHelper.size45,
      height: UIHelper.size35,
      padding: EdgeInsets.all(UIHelper.size5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(UIHelper.size5)),
      child: TextField(
        cursorColor: Colors.white,
        cursorWidth: 1,
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce.cancel();
          _debounce = Timer(
              const Duration(milliseconds: 500), () => onChangedText(text));
        },
        autocorrect: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: textStyleSemiBold(size: 20, color: Colors.white),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: textStyleSemiBold(size: 20, color: Colors.white),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero),
        textInputAction: TextInputAction.done,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: this.keyword,
            selection: TextSelection.collapsed(offset: length - 1),
          ),
        ),
      ),
    );
  }
}
