import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

class ItemOptionWidget extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  final TextStyle titleStyle;
  final double iconHeight;
  final double iconWidth;

  ItemOptionWidget(this.image, this.title,
      {this.onTap, this.titleStyle, this.iconHeight, this.iconWidth});
      
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: AppColor.GREY_BACKGROUND,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                image,
                width: this.iconWidth ?? 40,
                height: this.iconHeight ?? 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.title + '\n',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: this.titleStyle ?? Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
