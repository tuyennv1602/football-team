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
    double itemWidth = (UIHelper.screenWidth - UIHelper.size20) / 3;
    double logoSize;
    Color color;
    if (number == 1) {
      logoSize = UIHelper.size(150);
      color = Colors.green;
    } else if (number == 2) {
      logoSize = UIHelper.size(130);
      color = Colors.grey;
    } else {
      logoSize = UIHelper.size(110);
      color = Colors.brown;
    }
    return Container(
      height: UIHelper.size(200),
      width: itemWidth,
      padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: itemWidth,
            height: logoSize,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: color, width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ImageWidget(
                  source: team.logo,
                  placeHolder: Images.DEFAULT_LOGO,
                  size: logoSize - UIHelper.size(60),
                ),
                Text(
                  '${team.point}',
                  style: textStyleSemiBold(),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
            child: Text(
              team.name,
              style: textStyleSemiBold(size: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      _buildItem(context, firstTeam, 1),
      _buildItem(context, secondTeam, 2),
      _buildItem(context, thirdTeam, 3)
    ]);
  }
}
