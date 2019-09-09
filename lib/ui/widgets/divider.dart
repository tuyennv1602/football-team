import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 10,
      endIndent: 10,
      color: AppColor.LINE_COLOR,
    );
  }

}