import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui-helper.dart';

class TabBarWidget extends StatelessWidget {
  final List<String> titles;
  final bool isScrollable;

  TabBarWidget({Key key, @required this.titles, this.isScrollable = false})
      : assert(titles != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIHelper.size(35),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: LINE_COLOR, width: 1))),
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
        unselectedLabelStyle: textStyleRegular(size: 15),
        labelColor: PRIMARY,
        unselectedLabelColor: BLACK_TEXT,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: UIHelper.size(10)),
          borderSide:
              BorderSide(width: UIHelper.size(2), color: PRIMARY),
        ),
      ),
    );
  }
}
