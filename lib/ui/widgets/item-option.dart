import 'package:flutter/material.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui-helper.dart';

class ItemOptionWidget extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  final TextStyle titleStyle;
  final double iconHeight;
  final double iconWidth;
  final Color iconColor;

  ItemOptionWidget(this.image, this.title,
      {Key key,
      this.onTap,
      this.titleStyle,
      this.iconHeight,
      this.iconWidth,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: UIHelper.size(10), horizontal: UIHelper.size(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  width: this.iconWidth ?? UIHelper.size(25),
                  height: this.iconHeight ?? UIHelper.size(25),
                  color: this.iconColor,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: UIHelper.size(20)),
                  child: Text(
                    this.title,
                    style: this.titleStyle ?? textStyleRegular(size: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
