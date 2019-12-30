import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';

class AppBarButton extends StatelessWidget {
  final String imageName;
  final Function onTap;
  final double padding;
  final double _kButtonAppbarHeight = UIHelper.size(50);
  final Color iconColor;
  final Color backgroundColor;

  AppBarButton(
      {Key key,
      this.imageName,
      this.onTap,
      this.padding,
      this.iconColor = Colors.white,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kButtonAppbarHeight,
      width: _kButtonAppbarHeight,
      child: (imageName != null && onTap != null)
          ? InkWell(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.all(
                    backgroundColor != null ? UIHelper.size5 : 0),
                padding: EdgeInsets.all(this.padding ?? UIHelper.size(15)),
                decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(_kButtonAppbarHeight / 2)),
                child: Image.asset(
                  imageName,
                  color: iconColor,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
