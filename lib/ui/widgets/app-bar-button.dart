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
      child: (imageName != null && onTap != null)
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(this.padding ?? 15),
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
