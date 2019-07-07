import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

class AppBarWidget extends StatelessWidget {
  final appBarHeight;
  final Widget leftContent;
  final Widget centerContent;
  final Widget rightContent;
  final bool showBorder;
  final bool removePadding;
  final double paddingLeft;
  final double paddingRight;
  final Color backgroundColor;

  AppBarWidget(
      {this.appBarHeight,
      this.leftContent,
      this.rightContent,
      @required this.centerContent,
      this.removePadding = false,
      this.paddingLeft,
      this.paddingRight,
      this.backgroundColor,
      this.showBorder = false});

  @override
  Widget build(BuildContext context) => Container(
        height: appBarHeight ?? 50,
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColor.GREEN,
            border: showBorder
                ? Border(bottom: BorderSide(width: 0.5, color: AppColor.LINE_COLOR))
                : null),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            leftContent ??
                SizedBox(
                  width: paddingLeft ?? 0,
                ),
            Expanded(child: centerContent),
            rightContent ??
                SizedBox(
                  width: paddingRight ?? 0,
                )
          ],
        ),
      );
}
