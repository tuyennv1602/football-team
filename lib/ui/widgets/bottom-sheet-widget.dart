import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/utils/device-util.dart';

typedef void OnClickOption(int index);

class BottomSheetWidget extends StatelessWidget {
  final List<String> options;
  final OnClickOption onClickOption;
  List<Widget> children = [];
  static const double BUTTON_HEIGHT = 50;

  BottomSheetWidget({@required this.options, this.onClickOption});

  @override
  Widget build(BuildContext context) {
    int length = options.length;
    this.options.asMap().forEach((index, value) {
      if (index == 0) {
        children.add(SizedBox(
          height: BUTTON_HEIGHT,
          child: Center(
            child: Text(
              value,
              style: TextStyle(color: Colors.black, fontFamily: 'semi-bold', fontSize: 18),
            ),
          ),
        ));
      } else if (index == length - 1) {
        children.add(ButtonWidget(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          height: BUTTON_HEIGHT,
          child: Text(
            value,
            style: TextStyle(
                fontFamily: 'semi-bold', fontSize: 16, letterSpacing: 0.1, color: Colors.red),
          ),
          onTap: () => Navigator.of(context).pop(),
        ));
      } else {
        children.add(ButtonWidget(
          height: BUTTON_HEIGHT,
          child: Text(
            value,
            style: TextStyle(
                fontFamily: 'regular', fontSize: 16, letterSpacing: 0.1, color: Colors.black87),
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
      height: ((length * BUTTON_HEIGHT) + length).toDouble(),
      margin: EdgeInsets.only(left: 15, right: 15, bottom: DeviceUtil.getPaddingBottom(context)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: this.children,
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
