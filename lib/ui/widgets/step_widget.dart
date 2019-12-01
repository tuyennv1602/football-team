import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/status_indicator.dart';
import 'package:myfootball/utils/ui_helper.dart';

class StepWidget extends StatelessWidget {
  final int step;
  final String firstTitle;
  final String secondTitle;
  final String thirdTitle;

  const StepWidget(
      {Key key,
      @required this.step,
      @required this.firstTitle,
      @required this.secondTitle,
      @required this.thirdTitle})
      : super(key: key);

  Widget _buildIndicator(int index, bool isActive) => Row(
        children: <Widget>[
          Expanded(
            flex: index == 2 ? 2 : 1,
            child: Container(
                height: index != 0 ? 2 : 0,
                color: isActive ? GREEN_TEXT : SHADOW_GREY),
          ),
          StatusIndicator(
            isActive: isActive,
          ),
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: Container(
                height: index != 2 ? 2 : 0,
                color: isActive ? GREEN_TEXT : SHADOW_GREY),
          )
        ],
      );

  Widget _buildTitle(int index, String title, bool isActive) => Text(
        title,
        textAlign: index == 0
            ? TextAlign.left
            : index == 1 ? TextAlign.center : TextAlign.right,
        style: textStyleRegularBody(size: 13, color: isActive ? GREEN_TEXT : Colors.grey),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(flex: 2, child: _buildIndicator(0, step >= 1)),
            Expanded(flex: 3, child: _buildIndicator(1, step >= 2)),
            Expanded(flex: 2, child: _buildIndicator(2, step >= 3)),
          ],
        ),
        UIHelper.verticalSpaceSmall,
        Row(
          children: <Widget>[
            Expanded(flex: 2, child: _buildTitle(0, firstTitle, step == 1)),
            Expanded(flex: 3, child: _buildTitle(1, secondTitle, step == 2)),
            Expanded(flex: 2, child: _buildTitle(2, thirdTitle, step == 3)),
          ],
        )
      ],
    );
  }
}
