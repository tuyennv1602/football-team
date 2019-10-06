import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/ui-helper.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final Color backgroundColor;
  final String hintText;
  final double _kSearchHeight = UIHelper.size(42);
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
      margin: EdgeInsets.all(UIHelper.size(10)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kSearchHeight / 2),
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: PRIMARY,
              cursorWidth: 1,
              onChanged: (text) {
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 500),
                    () => onChangedText(text));
              },
              autocorrect: false,
              style: textStyleRegular(size: 16),
              decoration: InputDecoration(
                  hintText: this.hintText,
                  hintStyle: textStyleRegular(color: Colors.grey, size: 16),
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
          ButtonWidget(
            width: _kSearchHeight,
            height: _kSearchHeight,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(_kSearchHeight / 2),
            onTap: () {
              if (length > 0) {
                onChangedText('');
              }
            },
            child: this.isLoading
                ? Image.asset('assets/images/icn_loading.gif')
                : Icon(
                    length > 0 ? Icons.close : Icons.search,
                    color: Colors.grey,
                  ),
          )
        ],
      ),
    );
  }
}
