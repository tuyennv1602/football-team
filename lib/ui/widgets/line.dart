import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

class LineWidget extends StatelessWidget {
  final double indent;

  LineWidget({this.indent = 10});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: UIHelper.size(indent),
      endIndent: UIHelper.size(indent),
      color: LINE_COLOR,
    );
  }
}
