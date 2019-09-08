import 'package:flutter/material.dart';
import 'package:myfootball/blocs/social-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/utils/device-util.dart';

// ignore: must_be_immutable
class SocialPage extends BasePage<SocialBloc> {
  Widget _buildCateTitle(String title) => Text(
        title,
        style: TextStyle(
          color: AppColor.GREEN,
          fontFamily: 'bold',
          fontSize: 18,
        ),
      );

  Widget _buildItemNew(BuildContext context, int index) => Container(
        width: DeviceUtil.getWidth(context) / 2,
        margin: EdgeInsets.only(right: 10),
        decoration:
            BoxDecoration(color: AppColor.GREY_BACKGROUND, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Text("Item $index"),
      );

  Widget _buildNewsest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCateTitle('Tin tức mới nhất'),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
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
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
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
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
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
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
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
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Text(
          'Cộng đồng',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        _buildNewsest(context),
        _buildRanking(context),
        _buildTournament(context),
        _buildRecruit(context)
      ],
    );
  }

  @override
  void listenData(BuildContext context) {}

  @override
  bool get hasBottomBar => true;
}
