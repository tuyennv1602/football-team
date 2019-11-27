import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/top_ranking.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatelessWidget {
  Widget _buildCateTitle(String title) => Text(
        title,
        style: textStyleSemiBold(size: 17),
      );

  Widget _buildItemNew(BuildContext context, int index) => Container(
        width: UIHelper.screenWidth / 2,
        margin: EdgeInsets.only(right: UIHelper.size10),
        decoration: BoxDecoration(
            color: GREY_BACKGROUND,
            borderRadius: BorderRadius.circular(UIHelper.size10)),
        padding: EdgeInsets.all(UIHelper.size10),
        child: Text("Item $index"),
      );

  Widget _buildNewest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCateTitle('Tin tức mới nhất'),
        UIHelper.verticalSpaceMedium,
        Container(
            margin: EdgeInsets.only(bottom: UIHelper.size10),
            height: UIHelper.size(150),
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, index) => _buildItemNew(context, index),
            )),
      ],
    );
  }

  Widget _buildRanking(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildCateTitle('Bảng xếp hạng'),
            InkWell(
              onTap: () => NavigationService.instance.navigateTo(RANKING),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                child: Text(
                  'Xem Top 100',
                  style: textStyleSemiBold(color: Colors.grey, size: 15),
                ),
              ),
            )
          ],
        ),
        UIHelper.verticalSpaceMedium,
        Container(
          margin: EdgeInsets.only(bottom: UIHelper.size20),
          height: UIHelper.size(210),
          child: TopRankingWidget(
            firstTeam: Provider.of<Team>(context),
            secondTeam: Provider.of<Team>(context),
            thirdTeam: Provider.of<Team>(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTournament(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCateTitle('Giải đấu'),
        UIHelper.verticalSpaceMedium,
        Container(
            margin: EdgeInsets.only(bottom: UIHelper.size10),
            height: UIHelper.size(150),
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, index) => _buildItemNew(context, index),
            )),
      ],
    );
  }

  Widget _buildRecruit(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCateTitle('Thông tin tuyển quân'),
        UIHelper.verticalSpaceMedium,
        Container(
            height: UIHelper.size(150),
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, index) => _buildItemNew(context, index),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Cộng đồng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
          ),
          Expanded(
              child: BorderBackground(
            child: ListView(
              padding: EdgeInsets.all(UIHelper.size10),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                _buildRanking(context),
                _buildNewest(context),
//                _buildTournament(context),
                _buildRecruit(context)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
