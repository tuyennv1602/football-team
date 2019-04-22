import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function onTap;
  final double borderRadius;

  ButtonWidget(
      {@required this.child,
      @required this.onTap,
      this.backgroundColor,
      this.margin,
      this.padding,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        alignment: Alignment.center,
        margin: this.margin ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(this.borderRadius ?? 0),
          child: Material(
            color: this.backgroundColor ?? Colors.white,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: this.padding ?? EdgeInsets.all(5),
                child: this.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
