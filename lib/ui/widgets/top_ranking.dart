import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
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
    var medal;
    var bottom;
    if (number == 1) {
      medal = 'assets/images/ic_purple.png';
      bottom = 'assets/images/ic_purple_bottom.png';
    } else if (number == 2) {
      medal = 'assets/images/ic_gold.png';
      bottom = 'assets/images/ic_gold_bottom.png';
    } else {
      medal = 'assets/images/ic_green.png';
      bottom = 'assets/images/ic_green_bottom.png';
    }
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(medal),
              ),
            ),
            child: team != null && team.logo != null
                ? ImageWidget(
                    source: team.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size(60),
                  )
                : Image.asset(
                    Images.DEFAULT_LOGO,
                    width: UIHelper.size(60),
                    height: UIHelper.size(60),
                  ),
          ),
        ),
        Container(
          height: UIHelper.size25,
          margin: EdgeInsets.symmetric(horizontal: UIHelper.size5),
          width: double.infinity,
          decoration:
              BoxDecoration(image: DecorationImage(image: AssetImage(bottom), fit: BoxFit.cover)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIHelper.size(150),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(child: _buildItem(context, firstTeam, 1)),
          Expanded(child: _buildItem(context, secondTeam, 2)),
          Expanded(child: _buildItem(context, thirdTeam, 3))
        ],
      ),
    );
  }
}
