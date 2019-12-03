import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  final Widget widget;
  int duration;

  SlideUpRoute({this.widget, this.duration = 250})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero)
                      .animate(animation),
              child: child);
        });

  @override
  Duration get transitionDuration => Duration(milliseconds: duration);
}
