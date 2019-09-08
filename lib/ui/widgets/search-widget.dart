import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);

class SearchWidget extends StatelessWidget {
  final String keyword;
  final OnChangedText onChangedText;
  final OnSubmitText onSubmitText;
  final Color backgroundColor;
  final String hintText;
  static const double HEIGHT = 40;

  SearchWidget(
      {this.keyword = '',
      this.onChangedText,
      this.onSubmitText,
      this.backgroundColor,
      this.hintText = 'Nhập từ khoá'});

  @override
  Widget build(BuildContext context) {
    int length = this.keyword.length;
    return Container(
      height: HEIGHT,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HEIGHT / 2),
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: AppColor.GREEN,
              cursorWidth: 1,
              onSubmitted: onSubmitText,
              onChanged: onChangedText,
              style: Theme.of(context).textTheme.body1,
              decoration: InputDecoration(
                  hintText: this.hintText,
                  hintStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, right: 15)),
              textInputAction: TextInputAction.search,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: this.keyword, selection: TextSelection.collapsed(offset: length))),
            ),
          ),
          ButtonWidget(
            width: HEIGHT,
            height: HEIGHT,
            borderRadius: BorderRadius.circular(HEIGHT / 2),
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
