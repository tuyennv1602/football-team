import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/utils/ui-helper.dart';

class LineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.7,
      indent: UIHelper.size(10),
      endIndent: UIHelper.size(10),
      color: LINE_COLOR,
    );
  }
}