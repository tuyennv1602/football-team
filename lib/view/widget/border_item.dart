import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/view/ui_helper.dart';

class BorderItem extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double blurRadius;
  final Function onTap;

  const BorderItem(
      {Key key,
      this.borderRadius,
      this.margin,
      this.padding,
      this.child,
      this.backgroundColor,
      this.blurRadius = 4,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin ?? EdgeInsets.symmetric(horizontal: UIHelper.padding),
      decoration: BoxDecoration(
        color: this.backgroundColor ?? Colors.white,
        borderRadius:
            this.borderRadius ?? BorderRadius.circular(UIHelper.size10),
        boxShadow: [
          BoxShadow(
            color: SHADOW_GREY,
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          borderRadius:
              this.borderRadius ?? BorderRadius.circular(UIHelper.size10),
          onTap: onTap,
          child: Padding(
            padding: this.padding ?? EdgeInsets.all(UIHelper.padding),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
