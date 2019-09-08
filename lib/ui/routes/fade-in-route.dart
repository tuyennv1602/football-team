import 'package:flutter/material.dart';

class FadeInRoute extends PageRouteBuilder {
  final Widget widget;
  int duration;

  FadeInRoute({@required this.widget, this.duration = 250})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

  @override
  Duration get transitionDuration => Duration(milliseconds: duration);
}
