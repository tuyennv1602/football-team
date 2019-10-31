import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class TabBarWidget extends StatelessWidget {
  final List<String> titles;
  final bool isScrollable;
  final double height;

  TabBarWidget(
      {Key key, @required this.titles, this.isScrollable = false, this.height})
      : assert(titles != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? UIHelper.size40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: LINE_COLOR, width: 0.5))),
      child: TabBar(
        tabs: titles
            .map(
              (title) => Align(
                child: Text(title),
              ),
            )
            .toList(),
        labelStyle: textStyleSemiBold(),
        isScrollable: isScrollable,
        unselectedLabelStyle: textStyleRegularTitle(),
        labelColor: PRIMARY,
        unselectedLabelColor: BLACK_TEXT,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: UIHelper.size5),
          borderSide: BorderSide(width: UIHelper.size(2), color: PRIMARY),
        ),
      ),
    );
  }
}
