import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/utils/ui-helper.dart';

class SocialPage extends StatelessWidget {
  Widget _buildCateTitle(String title) => Text(
        title,
        style: textStyleSemiBold(color: PRIMARY),
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

  Widget _buildNewsest(BuildContext context) {
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
        _buildCateTitle('Bảng xếp hạng'),
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
    UIHelper().init(context);
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
                _buildNewsest(context),
                _buildRanking(context),
                _buildTournament(context),
                _buildRecruit(context)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
