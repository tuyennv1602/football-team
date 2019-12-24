import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/router/router_paths.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/ranking_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingPage extends StatelessWidget {
  final RefreshController _rankingController = RefreshController();

  _buildItemTeam(Team team) => InkWell(
        onTap: () =>
            Navigation.instance.navigateTo(TEAM_DETAIL, arguments: team),
        child: Padding(
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
                    ? Hero(
                        tag: team.tag,
                        child: ImageWidget(
                          source: team.logo,
                          placeHolder: Images.DEFAULT_LOGO,
                          size: UIHelper.size25,
                        ))
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
        ),
      );

  _buildTopBar() => Row(
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
            centerContent: Text('Bảng xếp hạng',
                textAlign: TextAlign.center, style: textStyleTitle()),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIHelper.padding),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: UIHelper.padding),
                      child: _buildTopBar(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: UIHelper.size10, bottom: UIHelper.size5),
                      child: LineWidget(indent: 0),
                    ),
                    Expanded(
                      child: BaseWidget<RankingViewModel>(
                        model: RankingViewModel(api: Provider.of(context)),
                        onModelReady: (model) => model.getRanking(false),
                        builder: (c, model, child) => model.busy
                            ? LoadingWidget()
                            : SmartRefresher(
                                controller: _rankingController,
                                onRefresh: () async {
                                  await model.getRanking(true);
                                  _rankingController.refreshCompleted();
                                },
                                header: RefreshLoading(),
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (c, index) =>
                                      _buildItemTeam(model.teams[index]),
                                  separatorBuilder: (c, index) => SizedBox(),
                                  itemCount: model.teams.length,
                                  physics: BouncingScrollPhysics(),
                                ),
                              ),
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
