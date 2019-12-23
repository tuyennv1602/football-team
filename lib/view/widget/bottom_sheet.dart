import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

import 'button_widget.dart';

typedef void OnClickOption(int index);

// ignore: must_be_immutable
class BottomSheetWidget extends StatelessWidget {
  final List<String> options;
  final OnClickOption onClickOption;
  List<Widget> children = [];
  final double _kButtonHeight = UIHelper.size(50);
  final double paddingBottom;

  BottomSheetWidget(
      {Key key, @required this.options, this.onClickOption, this.paddingBottom})
      : assert(options != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = options.length;
    options.asMap().forEach((index, value) {
      if (index == 0) {
        children.add(
          SizedBox(
            height: _kButtonHeight,
            child: Center(
              child: Text(
                value,
                style: textStyleSemiBold(color: Colors.black, size: 17),
              ),
            ),
          ),
        );
      } else if (index == length - 1) {
        children.add(
          ButtonWidget(
            height: _kButtonHeight,
            elevation: 0,
            borderRadius: BorderRadius.circular(0),
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size10),
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: textStyleSemiBold(color: Colors.red),
              ),
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        );
      } else {
        children.add(
          ButtonWidget(
            height: _kButtonHeight,
            elevation: 0,
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(0),
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size10),
              child: Text(
                value,
                style: textStyleAlert(size: 16, color: Colors.black),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onClickOption(index);
            },
          ),
        );
      }
      children.add(Container(
        height: 1,
        color: index != length - 1 ? Colors.grey[200] : Colors.transparent,
      ));
    });
    return Container(
      color: Colors.transparent,
      child: Wrap(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(UIHelper.radius)),
            ),
            padding: EdgeInsets.only(
                bottom: paddingBottom ?? UIHelper.paddingBottom),
            child: Column(
              children: this.children,
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          )
        ],
      ),
    );
  }
}
