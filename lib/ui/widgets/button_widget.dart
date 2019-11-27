import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

final double _kButtonHeight = 50;

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final Function onTap;
  final double width;
  final double elevation;
  final double height;
  final BorderRadius borderRadius;

  ButtonWidget(
      {Key key,
      @required this.child,
      @required this.onTap,
      this.backgroundColor,
      this.margin,
      this.width,
      this.height,
      this.elevation = 3,
      this.borderRadius})
      : assert(child != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height ?? _kButtonHeight,
        alignment: Alignment.center,
        margin: this.margin ?? EdgeInsets.zero,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(UIHelper.size10),
          ),
          elevation: elevation,
          color: backgroundColor ?? PRIMARY,
          onPressed: onTap,
          child: Align(
            alignment: Alignment.center,
            child: this.child,
          ),
        ),
      );
}
