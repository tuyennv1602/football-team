import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/item_member.dart';
import 'package:myfootball/ui/widget/item_option.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/matching_detail_viewmodel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class MatchHistoryDetailPage extends StatelessWidget {
  final MatchHistory matchHistory;

  MatchHistoryDetailPage({Key key, @required MatchHistory matchHistory})
      : matchHistory = matchHistory,
        super(key: key);

  Widget _buildTeamMembers(BuildContext context, List<Member> members) {
    if (members == null) return LoadingWidget();
    return members.length == 0
        ? EmptyWidget(message: 'Chưa có thành viên nào')
        : GridView.builder(
            padding: EdgeInsets.all(UIHelper.padding),
            itemBuilder: (c, index) => ItemMember(
                member: members[index], isCaptain: members[index].isManager),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: UIHelper.size10,
                mainAxisSpacing: UIHelper.size10),
            itemCount: members.length);
  }

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [PRIMARY, Color(0xFFE5F230)])),
        child: Column(
          children: <Widget>[
            AppBarWidget(
              centerContent: Text(
                'Kết quả trận đấu',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => NavigationService.instance.goBack(),
              ),
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: UIHelper.size(50)),
                    child: BorderBackground(
                      child: BaseWidget<MatchingDetailViewModel>(
                        model:
                            MatchingDetailViewModel(api: Provider.of(context)),
                        onModelReady: (model) {
                          model.getMyTeamMembers(matchHistory.matchId, team.id);
                          if (matchHistory.receiveTeam != null) {
                            model.getOpponentTeamMembers(matchHistory.matchId,
                                matchHistory.getOpponentTeam.id);
                          }
                        },
                        builder: (c, model, child) => Padding(
                          padding: EdgeInsets.only(top: UIHelper.size50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.size15,
                                    vertical: UIHelper.size5),
                                child: Row(
                                  children: <Widget>[
                                    LikeButton(
                                      size: UIHelper.size30,
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.check_circle,
                                          color:
                                              isLiked ? PRIMARY : Colors.grey,
                                          size: UIHelper.size30,
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UIHelper.size5),
                                        child: LinearPercentIndicator(
                                          animation: true,
                                          lineHeight: UIHelper.size(6),
                                          animationDuration: 1000,
                                          percent: matchHistory.getRatePercent,
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          progressColor:
                                              matchHistory.getRateColor,
                                          backgroundColor: LINE_COLOR,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+${matchHistory.getBonus.toStringAsFixed(2)}',
                                      style: textStyleSemiBold(
                                          size: 16,
                                          color: matchHistory.getRateColor),
                                    )
                                  ],
                                ),
                              ),
                              ItemOptionWidget(
                                Images.STADIUM,
                                matchHistory.groundName,
                                iconColor: Colors.green,
                                onTap: () => NavigationService.instance
                                    .navigateTo(GROUND_DETAIL,
                                        arguments: matchHistory.groundId),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.padding,
                                    vertical: UIHelper.size10),
                                child: Text(
                                  'Danh sách thi đấu',
                                  style: textStyleSemiBold(),
                                ),
                              ),
                              Expanded(
                                child: matchHistory.receiveTeam != null
                                    ? DefaultTabController(
                                        length: 2,
                                        child: Column(
                                          children: <Widget>[
                                            TabBarWidget(
                                              titles: [
                                                team.name,
                                                matchHistory.getOpponentName
                                              ],
                                              height: UIHelper.size35,
                                            ),
                                            Expanded(
                                              child: TabBarView(children: [
                                                _buildTeamMembers(context,
                                                    model.myTeamMembers),
                                                _buildTeamMembers(context,
                                                    model.opponentTeamMembers)
                                              ]),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _buildTeamMembers(
                                        context, model.myTeamMembers),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: UIHelper.size(100),
                    margin: EdgeInsets.symmetric(horizontal: UIHelper.size20),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UIHelper.radius),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ImageWidget(
                              source: team.logo,
                              placeHolder: Images.DEFAULT_LOGO,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${matchHistory.getMyTeamScore} - ${matchHistory.getOpponentTeamScore}',
                                textAlign: TextAlign.center,
                                style: textStyleBold(
                                    size: 30,
                                    color: matchHistory.isConfirmed
                                        ? Colors.red
                                        : Colors.grey),
                              ),
                              Row(
                                children: <Widget>[
                                  matchHistory.isConfirmed
                                      ? Text(
                                          matchHistory.getMyTeamPoint
                                              .toStringAsFixed(2),
                                          style: textStyleSemiBold(
                                              size: 14,
                                              color:
                                                  matchHistory.getMyTeamPoint >
                                                          0
                                                      ? GREEN_TEXT
                                                      : Colors.red),
                                        )
                                      : SizedBox(),
                                  matchHistory.isConfirmed
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: Image.asset(
                                            matchHistory.getMyTeamPoint > 0
                                                ? Images.UP
                                                : Images.DOWN,
                                            width: UIHelper.size(12),
                                            height: UIHelper.size(12),
                                            color:
                                                matchHistory.getMyTeamPoint > 0
                                                    ? GREEN_TEXT
                                                    : Colors.red,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: matchHistory.getOpponentTeam != null
                                ? InkWell(
                                    onTap: () => NavigationService.instance
                                        .navigateTo(TEAM_DETAIL,
                                            arguments:
                                                matchHistory.getOpponentTeam),
                                    child: Hero(
                                      tag: matchHistory.getOpponentTeam.id,
                                      child: ImageWidget(
                                        source: matchHistory.getOpponentLogo,
                                        placeHolder: Images.DEFAULT_LOGO,
                                      ),
                                    ),
                                  )
                                : Image.asset(Images.DEFAULT_LOGO,
                                    width: UIHelper.size50,
                                    height: UIHelper.size50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
