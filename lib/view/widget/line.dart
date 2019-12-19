import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

class LineWidget extends StatelessWidget {
  final double indent;
  final Color color;
  final double height;

  LineWidget({this.indent = 10, this.color = LINE_COLOR, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      indent: UIHelper.size(indent),
      endIndent: UIHelper.size(indent),
      color: color,
    );
  }
}
