import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/line.dart';

import 'image_widget.dart';
import 'item_achievement.dart';

class TeamHeader extends StatelessWidget {
  final Team team;
  final bool anim;

  const TeamHeader({Key key, @required this.team, this.anim = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.size15, vertical: UIHelper.size10),
              child: anim
                  ? Hero(
                      tag: team.tag,
                      child: ImageWidget(
                        source: team.logo,
                        placeHolder: Images.DEFAULT_LOGO,
                        size: UIHelper.size(80),
                      ),
                    )
                  : ImageWidget(
                      source: team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size(80),
                    ),
            ),
            Expanded(
              child: SizedBox(
                height: UIHelper.size(60),
                child: ListView(
                  padding: EdgeInsets.only(right: UIHelper.size15),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ItemAchievement(
                      icon: Images.RANK,
                      title: 'Hạng',
                      value: team.getRank,
                      colors: PINK_GRADIENT,
                    ),
                    SizedBox(
                      width: UIHelper.size10,
                    ),
                    ItemAchievement(
                      icon: Images.JEWISH,
                      title: 'Điểm',
                      value: team.getPoint,
                      colors: ORANGE_GRADIENT,
                    ),
                    SizedBox(
                      width: UIHelper.size10,
                    ),
                    ItemAchievement(
                      icon: Images.STAR,
                      title: 'Đánh giá',
                      value: team.getRating,
                      colors: YELLOW_GRADIENT,
                    ),
                    SizedBox(
                      width: UIHelper.size10,
                    ),
                    ItemAchievement(
                      icon: Images.VERIFIED,
                      title: 'Tín nhiệm',
                      value: team.getTrustPoint,
                      colors: PURPLE_GRADIENT,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: UIHelper.size(110), right: UIHelper.padding),
          child: Text(
            team.bio ?? '',
            style: textStyleRegular(color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: LineWidget(),
        )
      ],
    );
  }
}
