import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

class RotationWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget widget;
  final Duration duration;

  RotationWidget({this.widget, this.width, this.height, this.duration});

  @override
  State<StatefulWidget> createState() => RotationState();
}

class RotationState extends State<RotationWidget> with SingleTickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController =
        AnimationController(duration: widget.duration ?? Duration(milliseconds: 1000), vsync: this);
    rotationController.repeat();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 55,
      height: widget.height ?? 55,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.WHITE_OPACITY,
      ),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
        child: widget.widget,
      ),
    );
  }
}
