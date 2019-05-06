import 'package:flutter/material.dart';

class AppBarButtonWidget extends StatelessWidget {
  final String imageName;
  final Function onTap;
  final double padding;

  AppBarButtonWidget({this.imageName, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(this.padding ?? 15),
      child: (imageName != null && onTap != null)
          ? InkWell(
              onTap: onTap,
              child: Image.asset(
                'assets/images/$imageName',
                color: Colors.white,
              ),
            )
          : SizedBox(),
    );
  }
}
