import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/utils/ui_helper.dart';

class RankingPage extends StatelessWidget {
  final List<Team> teams;

  RankingPage({Key key, @required this.teams}) : super(key: key);

  Widget _buildItemTeam(Team team) => Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: UIHelper.size30,
              child: Text(
                '${team.rank}',
                style: textStyleMediumTitle(size: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
              child: team.logo != null
                  ? ImageWidget(
                      source: team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size25,
                    )
                  : Image.asset(
                      Images.DEFAULT_LOGO,
                      width: UIHelper.size25,
                      height: UIHelper.size25,
                    ),
            ),
            Expanded(
              child: Text(
                team.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyleMediumTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size50,
              child: Text(
                team.mp.toString(),
                textAlign: TextAlign.right,
                style: textStyleMediumTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size50,
              child: Text(
                team.win.toString(),
                textAlign: TextAlign.right,
                style: textStyleMediumTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size(70),
              child: Text(
                team.point.toStringAsFixed(1),
                textAlign: TextAlign.right,
                style: textStyleMediumTitle(size: 15),
              ),
            )
          ],
        ),
      );

  Widget _buildTopBar() => Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Đội bóng',
              style: textStyleSemiBold(color: GREEN_TEXT),
            ),
          ),
          SizedBox(
            width: UIHelper.size50,
            child: Text(
              'M',
              textAlign: TextAlign.right,
              style: textStyleSemiBold(color: GREEN_TEXT),
            ),
          ),
          SizedBox(
            width: UIHelper.size50,
            child: Text(
              'W',
              textAlign: TextAlign.right,
              style: textStyleSemiBold(color: GREEN_TEXT),
            ),
          ),
          SizedBox(
            width: UIHelper.size(70),
            child: Text(
              'Điểm',
              textAlign: TextAlign.right,
              style: textStyleSemiBold(color: PRIMARY),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            centerContent: Text('Bảng xếp hạng',
                textAlign: TextAlign.center, style: textStyleTitle()),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.all(UIHelper.padding),
                child: Column(
                  children: <Widget>[
                    _buildTopBar(),
                    Padding(
                      padding: EdgeInsets.only(top: UIHelper.size10, bottom: UIHelper.size5),
                      child: LineWidget(indent: 0),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (c, index) =>
                            _buildItemTeam(teams[index]),
                        separatorBuilder: (c, index) => SizedBox(),
                        itemCount: teams.length,
                        physics: BouncingScrollPhysics(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
