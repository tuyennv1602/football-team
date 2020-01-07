import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/ui_helper.dart';

class AppBarWidget extends StatelessWidget {
  final Widget leftContent;
  final Widget centerContent;
  final Widget rightContent;
  final Color backgroundColor;
  final double _kAppbarHeight = UIHelper.size(55);

  AppBarWidget(
      {Key key,
      this.leftContent,
      this.rightContent,
      @required this.centerContent,
      this.backgroundColor})
      : assert(centerContent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: _kAppbarHeight + UIHelper.paddingTop,
          padding: EdgeInsets.only(top: UIHelper.paddingTop),
          decoration: BoxDecoration(
            color: backgroundColor ?? PRIMARY,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: GREEN_BUTTON,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              leftContent ?? AppBarButton(),
              Expanded(child: centerContent),
              rightContent ?? AppBarButton()
            ],
          ),
        ),
      ],
    );
  }
}
