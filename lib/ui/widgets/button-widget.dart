import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final Function onTap;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  ButtonWidget(
      {@required this.child,
      @required this.onTap,
      this.backgroundColor,
      this.margin,
      this.width,
      this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: this.margin ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Material(
            color: this.backgroundColor ?? Colors.white,
            child: InkWell(
              onTap: onTap,
              child: Align(
                alignment: Alignment.center,
                child: this.child,
              ),
            ),
          ),
        ),
      );
}
