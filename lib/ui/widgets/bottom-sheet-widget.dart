import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/utils/ui-helper.dart';

import 'button-widget.dart';

typedef void OnClickOption(int index);

// ignore: must_be_immutable
class BottomSheetWidget extends StatelessWidget {
  final List<String> options;
  final OnClickOption onClickOption;
  List<Widget> children = [];
  final double BUTTON_HEIGHT = UIHelper.size(50);

  BottomSheetWidget({Key key, @required this.options, this.onClickOption})
      : assert(options != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = options.length;
    options.asMap().forEach((index, value) {
      if (index == 0) {
        children.add(SizedBox(
          height: BUTTON_HEIGHT,
          child: Center(
            child: Text(
              value,
              style: textStyleSemiBold(color: PRIMARY),
            ),
          ),
        ));
      } else if (index == length - 1) {
        children.add(ButtonWidget(
          height: BUTTON_HEIGHT,
          child: Text(
            value,
            style: textStyleSemiBold(color: Colors.red),
          ),
          onTap: () => Navigator.of(context).pop(),
        ));
      } else {
        children.add(ButtonWidget(
          height: BUTTON_HEIGHT,
          child: Text(
            value,
            style: textStyleRegular(size: 16),
          ),
          onTap: () => onClickOption(index),
        ));
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
          BorderBackground(
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
