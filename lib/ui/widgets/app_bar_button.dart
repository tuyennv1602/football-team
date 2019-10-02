import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui-helper.dart';

class AppBarButtonWidget extends StatelessWidget {
  final String imageName;
  final Function onTap;
  final double padding;
  final double _kButtonAppbarHeight = UIHelper.size(50);

  AppBarButtonWidget({Key key, this.imageName, this.onTap, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kButtonAppbarHeight,
      width: _kButtonAppbarHeight,
      child: (imageName != null && onTap != null)
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(this.padding ?? UIHelper.size(15)),
                child: Image.asset(
                  imageName,
                  color: Colors.white,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
