import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/news.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/button_widget.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/top_ranking.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/social_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPage extends StatelessWidget {
  Widget _buildCateTitle(String title) => Text(
        title,
        style: textStyleSemiBold(size: 17),
      );

  Widget _buildItemNew(BuildContext context, News news) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => launch(news.getLink),
          child: Container(
            width: UIHelper.screenWidth * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIHelper.padding),
            ),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(UIHelper.padding),
                  child: SizedBox.expand(
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.DEFAULT_GROUND,
                      image: news.getImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: UIHelper.size(100),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(UIHelper.size10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: BLACK_GRADIENT,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(UIHelper.padding),
                        bottomRight: Radius.circular(UIHelper.padding),
                      ),
                    ),
                    child: Text(
                      news.getTitle,
                      maxLines: 2,
                      style: textStyleMediumTitle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildItemRecruit(BuildContext context, int index) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.zero,
        child: Container(
          width: UIHelper.screenWidth * 0.45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIHelper.padding)),
          padding: EdgeInsets.all(UIHelper.size10),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ImageWidget(
                    source: null,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size45,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: UIHelper.size10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Acazia FC',
                            style: textStyleMediumTitle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          RatingBarIndicator(
                            rating: 4,
                            itemCount: 5,
                            itemPadding: EdgeInsets.only(right: 2),
                            itemSize: UIHelper.size15,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: UIHelper.size5, bottom: UIHelper.size10),
                child: LineWidget(indent: 0),
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    Images.CLOCK,
                    width: UIHelper.size15,
                    height: UIHelper.size15,
                    color: Colors.deepPurpleAccent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: UIHelper.size5),
                      child: Text(
                        '16:30 31/12/19',
                        style: textStyleMedium(),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: UIHelper.size5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        Images.STADIUM,
                        width: UIHelper.size15,
                        height: UIHelper.size15,
                        color: Colors.green,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: UIHelper.size5),
                          child: Text(
                            'Sân bóng Thạch Cầu',
                            style: textStyleMedium(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(UIHelper.size5),
                child: Container(
                  height: UIHelper.size30,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF02DC37), PRIMARY],
                    ),
                  ),
                  child: Text(
                    'THAM GIA',
                    style: textStyleMedium(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildNewest(BuildContext context, bool isLoading, List<News> news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: UIHelper.padding, right: UIHelper.padding, top: UIHelper.size10),
          child: _buildCateTitle('Tin tức mới nhất'),
        ),
        SizedBox(
          height: UIHelper.size(180),
          child: isLoading
              ? LoadingWidget()
              : news == null
                  ? EmptyWidget(message: 'Có lỗi xảy ra')
                  : ListView.separated(
                      itemCount: news.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(UIHelper.padding),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (c, index) =>
                          _buildItemNew(context, news[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        width: UIHelper.padding,
                        height: 100,
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildRanking(BuildContext context, List<Team> teams) => Padding(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildCateTitle('Bảng xếp hạng'),
                teams.length != 0
                    ? InkWell(
                        onTap: () => NavigationService.instance
                            .navigateTo(RANKING, arguments: teams),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIHelper.size10),
                          child: Text(
                            'Xem Top 100',
                            style:
                                textStyleSemiBold(color: Colors.grey, size: 15),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: UIHelper.size20),
              padding: EdgeInsets.only(top: UIHelper.size10),
              child: TopRankingWidget(
                firstTeam: teams.length > 0 ? teams[0] : null,
                secondTeam: teams.length > 1 ? teams[1] : null,
                thirdTeam: teams.length > 2 ? teams[2] : null,
              ),
            ),
          ],
        ),
      );

  Widget _buildRecruit(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: UIHelper.padding, right: UIHelper.padding, top: UIHelper.size10),
          child: _buildCateTitle('Tin tuyển quân'),
        ),
        Container(
          height: UIHelper.size(210),
          child: ListView.separated(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(UIHelper.padding),
            physics: BouncingScrollPhysics(),
            itemBuilder: (c, index) => _buildItemRecruit(context, index),
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              width: UIHelper.padding,
              height: 100,
            ),
          ),
        ),
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
              child: BaseWidget<SocialViewModel>(
                model: SocialViewModel(api: Provider.of(context)),
                onModelReady: (model) {
                  model.getRanking();
                  model.getSportNews();
                },
                builder: (c, model, child) => ListView(
                  padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildRanking(context, model.teams),
                    LineWidget(indent: 0),
                    _buildNewest(context, model.isLoadingNews, model.news),
                    LineWidget(indent: 0),
                    _buildRecruit(context)
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
