import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

class SearchWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final OnSubmitText onSubmitText;
  final Color backgroundColor;
  final String hintText;
  final double _kSearchHeight = UIHelper.size(45);

  SearchWidget(
      {Key key,
      this.keyword = '',
      this.onChangedText,
      this.onSubmitText,
      this.backgroundColor,
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
              onSubmitted: onSubmitText,
              onChanged: onChangedText,
              style: Theme.of(context).textTheme.body1,
              decoration: InputDecoration(
                  hintText: this.hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: UIHelper.size(15))),
              textInputAction: TextInputAction.search,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: this.keyword,
                  selection: TextSelection.collapsed(offset: length))),
            ),
          ),
          ButtonWidget(
            width: _kSearchHeight,
            height: _kSearchHeight,
            borderRadius: BorderRadius.circular(_kSearchHeight / 2),
            onTap: () {
              if (length > 0) {
                onChangedText('');
              }
            },
            child: Icon(
              length > 0 ? Icons.close : Icons.search,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
