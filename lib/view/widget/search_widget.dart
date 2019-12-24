import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final Color backgroundColor;
  final String hintText;
  final double _kSearchHeight = UIHelper.size(45);
  final bool isLoading;
  Timer _debounce;

  SearchWidget(
      {Key key,
      this.keyword = '',
      this.onChangedText,
      this.backgroundColor,
      this.isLoading = false,
      this.hintText = 'Nhập từ khoá'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = this.keyword.length;
    return Container(
      height: _kSearchHeight,
      margin: EdgeInsets.all(UIHelper.padding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kSearchHeight / 2),
        boxShadow: [
          BoxShadow(
            color: LINE_COLOR,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: PRIMARY,
              cursorWidth: 1,
              onChanged: (text) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 300),
                    () => onChangedText(text));
              },
              autocorrect: false,
              style: textStyleRegular(size: 16),
              decoration: InputDecoration(
                  hintText: this.hintText,
                  hintStyle: textStyleRegular(size: 16, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: UIHelper.size(15))),
              textInputAction: TextInputAction.search,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: this.keyword,
                  selection: TextSelection.collapsed(offset: length),
                ),
              ),
            ),
          ),
          Container(
            width: _kSearchHeight,
            height: _kSearchHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_kSearchHeight / 2),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(_kSearchHeight / 2),
              onTap: () {
                if (length > 0) {
                  onChangedText('');
                }
              },
              child: this.isLoading
                  ? Image.asset('assets/images/ic_loading.gif')
                  : Icon(
                      length > 0 ? Icons.close : Icons.search,
                      color: Colors.grey,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
