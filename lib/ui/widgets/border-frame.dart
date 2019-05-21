import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

class BorderFrameWidget extends StatelessWidget {
  final EdgeInsets margin;
  final Widget child;
  final Color backgroundColor;

  BorderFrameWidget({this.margin, @required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        margin: this.margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: backgroundColor ?? AppColor.GREY_BACKGROUND),
        child: this.child,
      );
}
