import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class CustomizeTabBar extends StatelessWidget {
  final List<String> titles;
  final bool isScrollable;
  final double height;

  CustomizeTabBar(
      {Key key, @required this.titles, this.isScrollable = false, this.height})
      : assert(titles != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? UIHelper.size40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: LINE_COLOR, width: 0.5),
        ),
      ),
      child: TabBar(
        tabs: titles
            .map(
              (title) => Align(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        labelStyle: textStyleMediumTitle(),
        isScrollable: isScrollable,
        unselectedLabelStyle: textStyleMediumTitle(),
        labelColor: PRIMARY,
        unselectedLabelColor: Colors.grey,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: UIHelper.size5),
          borderSide: BorderSide(width: UIHelper.size(2), color: PRIMARY),
        ),
      ),
    );
  }
}
