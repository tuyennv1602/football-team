import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

const double _kButtonHeight = 46;

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final Function onTap;
  final double width;
  final double elevation;
  final double height;
  final BorderRadius borderRadius;
  final Alignment alignment;

  ButtonWidget(
      {Key key,
      @required this.child,
      @required this.onTap,
      this.backgroundColor,
      this.margin,
      this.width,
      this.height = _kButtonHeight,
      this.elevation = 3,
      this.alignment = Alignment.center,
      this.borderRadius})
      : assert(child != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: this.margin ?? EdgeInsets.zero,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(UIHelper.size10)),
          elevation: elevation,
          color: backgroundColor ?? PRIMARY,
          onPressed: onTap,
          child: Align(
            alignment: alignment,
            child: this.child,
          ),
        ),
      );
}
