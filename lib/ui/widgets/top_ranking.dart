import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';

class TopRankingWidget extends StatelessWidget {
  final Team firstTeam;
  final Team secondTeam;
  final Team thirdTeam;

  TopRankingWidget({Key key, this.firstTeam, this.secondTeam, this.thirdTeam})
      : super(key: key);

  Widget _buildItem(BuildContext context, Team team, int number) {
    double logoSize;
    Color color;
    if (number == 1) {
      logoSize = UIHelper.size(110);
      color = Colors.redAccent;
    } else if (number == 2) {
      logoSize = UIHelper.size(70);
      color = Colors.deepPurpleAccent;
    } else {
      logoSize = UIHelper.size(50);
      color = Colors.lightGreen;
    }
    return Container(
      height: UIHelper.size(210),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ImageWidget(source: team.logo, placeHolder: Images.DEFAULT_LOGO),
          UIHelper.verticalSpaceMedium,
          Container(
            width: double.infinity,
            height: UIHelper.size25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(number != 2 ? UIHelper.size10 : 0),
                topLeft: Radius.circular(number != 3 ? UIHelper.size10 : 0),
              ),
            ),
            child: Text(
              team.point.toString(),
              textAlign: TextAlign.center,
              style: textStyleBold(color: Colors.white),
            ),
          ),
          Container(
            width: double.infinity,
            height: logoSize,
            padding: EdgeInsets.only(top: UIHelper.size5),
            color: Colors.orangeAccent,
            child: Text(
              number.toString(),
              style: textStyleBold(size: 30, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: _buildItem(context, secondTeam, 2)),
      Expanded(child: _buildItem(context, firstTeam, 1)),
      Expanded(child: _buildItem(context, thirdTeam, 3))
    ]);
  }
}
