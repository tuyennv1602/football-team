import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/utils/ui-helper.dart';

class AppBarWidget extends StatelessWidget {
  final Widget leftContent;
  final Widget centerContent;
  final Widget rightContent;
  final bool showBorder;
  final Color backgroundColor;
  final double _kAppbarHeight = UIHelper.size(50);

  AppBarWidget(
      {Key key,
      this.leftContent,
      this.rightContent,
      @required this.centerContent,
      this.backgroundColor,
      this.showBorder = false})
      : assert(centerContent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: UIHelper.paddingTop,
        ),
        Container(
          height: _kAppbarHeight,
          decoration: BoxDecoration(
              color: backgroundColor ?? PRIMARY,
              border: showBorder
                  ? Border(bottom: BorderSide(width: 0.5, color: LINE_COLOR))
                  : null),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              leftContent ?? AppBarButtonWidget(),
              Expanded(child: centerContent),
              rightContent ?? AppBarButtonWidget()
            ],
          ),
        ),
      ],
    );
  }
}
