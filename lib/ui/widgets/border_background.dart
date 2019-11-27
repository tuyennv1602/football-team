import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';

class BorderBackground extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color backgroundColor;

  BorderBackground(
      {Key key, @required this.child, this.radius, this.backgroundColor})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(this.radius ?? UIHelper.radius),
            topLeft: Radius.circular(this.radius ?? UIHelper.radius)),
        child: Container(
          color: this.backgroundColor ?? Colors.white,
          child: this.child,
        ),
      ),
    );
  }
}
