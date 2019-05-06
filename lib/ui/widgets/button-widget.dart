import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final Function onTap;
  final double width;
  final double height;
  final double borderRadius;

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
          borderRadius: BorderRadius.circular(this.borderRadius ?? 0),
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
