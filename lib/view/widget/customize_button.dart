import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

const double _kButtonHeight = 46;

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final List<Color> backgroundColor;
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
        margin: this.margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          gradient: LinearGradient(
            colors: this.backgroundColor ?? GREEN_BUTTON,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Material(
          child: InkWell(
            splashColor: Color(0x1AFCFCFC),
            highlightColor: Colors.transparent,
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
            child: Align(
              alignment: alignment,
              child: this.child,
            ),
          ),
        ),
      );
}
