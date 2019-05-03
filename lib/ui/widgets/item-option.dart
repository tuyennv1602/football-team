import 'package:flutter/material.dart';

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
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                image,
                width: this.iconWidth ?? 35,
                height: this.iconHeight ?? 35,
              ),
              SizedBox(
                height: 5,
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
