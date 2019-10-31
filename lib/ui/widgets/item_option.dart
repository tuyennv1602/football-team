import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemOptionWidget extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  final TextStyle titleStyle;
  final double iconHeight;
  final double iconWidth;
  final Color iconColor;
  final Widget rightContent;

  ItemOptionWidget(this.image, this.title,
      {Key key,
      this.onTap,
      this.titleStyle,
      this.iconHeight,
      this.iconWidth,
      this.iconColor,
      this.rightContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: UIHelper.size15, horizontal: UIHelper.size20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  width: this.iconWidth ?? UIHelper.size20,
                  height: this.iconHeight ?? UIHelper.size20,
                  color: this.iconColor,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: UIHelper.size20),
                    child: Text(
                      this.title,
                      style: this.titleStyle ?? textStyleRegularTitle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                rightContent ??
                    Image.asset(
                      Images.NEXT,
                      width: UIHelper.size10,
                      height: UIHelper.size10,
                      color: LINE_COLOR,
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
