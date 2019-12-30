import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemAchievement extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final List<Color> colors;

  ItemAchievement({Key key, this.icon, this.title, this.value, this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIHelper.size10),
      child: Container(
        width: UIHelper.size(90),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 3,
              right: 3,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  icon,
                  width: UIHelper.size35,
                  height: UIHelper.size35,
                  color: GREY_BACKGROUND,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(UIHelper.size5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: textStyleMedium(color: Colors.white70),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    style: textStyleSemiBold(size: 18, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
