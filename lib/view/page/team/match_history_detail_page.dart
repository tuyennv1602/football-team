import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/item_member.dart';
import 'package:myfootball/view/widget/item_option.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/view/widget/customize_tabbar.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/match_history_detail_viewmodel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MatchHistoryDetailPage extends StatelessWidget {
  final MatchHistory matchHistory;
  MatchHistoryDetailViewModel _model;

  MatchHistoryDetailPage({Key key, @required MatchHistory matchHistory})
      : matchHistory = matchHistory,
        super(key: key);

   _buildTeamMembers(BuildContext context, List<Member> members) {
    if (members == null) return LoadingWidget();
    return members.length == 0
        ? EmptyWidget(message: 'Chưa có thành viên nào')
        : GridView.builder(
            padding: EdgeInsets.all(UIHelper.padding),
            itemBuilder: (c, index) {
              var _member = members[index];
              return ItemMember(
                member: _member,
                isManager: _member.isManager,
                isCaptain: _member.isCaptain,
                onTap: () => Navigation.instance
                    .navigateTo(USER_COMMENT, arguments: _member.id),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: UIHelper.size10,
                mainAxisSpacing: UIHelper.size10),
            itemCount: members.length);
  }

  @override
  Widget build(BuildContext context) {
    var team = matchHistory.getMyTeam;
    var _isLiked = matchHistory.userConfirmed;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [PRIMARY, Color(0xFFE5F230)],
          ),
        ),
        child: Column(
          children: <Widget>[
            CustomizeAppBar(
              centerContent: Text(
                'Kết quả trận đấu',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButton(
                imageName: Images.BACK,
                onTap: () => Navigation.instance.goBack(),
              ),
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: UIHelper.size40),
                    child: BorderBackground(
                      child: BaseWidget<MatchHistoryDetailViewModel>(
                        model: MatchHistoryDetailViewModel(
                            api: Provider.of(context),
                            matchHistory: matchHistory),
                        onModelReady: (model) {
                          _model = model;
                          model.getMyTeamMembers(team.id);
                          if (matchHistory.receiveTeam != null) {
                            model.getOpponentTeamMembers(
                                matchHistory.getOpponentTeam.id);
                          }
                        },
                        child: LikeButton(
                          size: UIHelper.size30,
                          isLiked: _isLiked,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.check_circle,
                              color: isLiked ? PRIMARY : Colors.grey,
                              size: UIHelper.size30,
                            );
                          },
                          onTap: (isLiked) {
                            if (isLiked) {
                              return _model.cancelConfirmScore().then((resp) {
                                _isLiked = !isLiked;
                                return _isLiked;
                              });
                            } else {
                              return _model.confirmScore().then((reps) {
                                _isLiked = !isLiked;
                                return _isLiked;
                              });
                            }
                          },
                        ),
                        builder: (c, model, child) => Padding(
                          padding: EdgeInsets.only(top: UIHelper.size50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              matchHistory.isConfirmed
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: UIHelper.size15,
                                          right: UIHelper.size15,
                                          top: UIHelper.size15,
                                          bottom: UIHelper.size5),
                                      child: Row(
                                        children: <Widget>[
                                          matchHistory.isAbleConfirm &&
                                                  matchHistory.isJoined
                                              ? child
                                              : SizedBox(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: UIHelper.size5),
                                            child: Text(
                                              matchHistory.getCurrentConfirm,
                                              style: textStyleSemiBold(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: UIHelper.size5),
                                              child: LinearPercentIndicator(
                                                animation: true,
                                                lineHeight: UIHelper.size(6),
                                                animationDuration: 1000,
                                                percent: model.matchHistory
                                                    .getRatePercent,
                                                linearStrokeCap:
                                                    LinearStrokeCap.roundAll,
                                                progressColor: model
                                                    .matchHistory.getRateColor,
                                                backgroundColor: LINE_COLOR,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '+${model.matchHistory.getBonus}',
                                            style: textStyleSemiBold(
                                                color:
                                                    matchHistory.getRateColor),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              ItemOption(
                                Images.STADIUM,
                                matchHistory.groundName,
                                iconColor: Colors.green,
                                onTap: () => Navigation.instance
                                    .navigateTo(GROUND_DETAIL,
                                        arguments: matchHistory.groundId),
                              ),
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.padding,
                                    vertical: UIHelper.size5),
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
                                            CustomizeTabBar(
                                              titles: [
                                                team.name,
                                                matchHistory.getOpponentName
                                              ],
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
                                    : Container(
                                        width: double.infinity,
                                        child: _buildTeamMembers(
                                            context, model.myTeamMembers),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: UIHelper.size(90),
                    margin: EdgeInsets.symmetric(horizontal: UIHelper.size20),
                    child: BorderItem(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomizeImage(
                              source: team.logo,
                              placeHolder: Images.DEFAULT_LOGO,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: UIHelper.size20,
                              ),
                              Text(
                                '${matchHistory.getMyTeamScore} - ${matchHistory.getOpponentTeamScore}',
                                textAlign: TextAlign.center,
                                style: textStyleBold(
                                    size: 30,
                                    color: matchHistory.isConfirmed
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                              SizedBox(
                                height: UIHelper.size20,
                                child: matchHistory.isConfirmed
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            matchHistory.getMyTeamPoint
                                                .toStringAsFixed(2),
                                            style: textStyleSemiBold(
                                                size: 14,
                                                color: matchHistory
                                                            .getMyTeamPoint >
                                                        0
                                                    ? GREEN_TEXT
                                                    : Colors.red),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2),
                                            child: Image.asset(
                                              matchHistory.getMyTeamPoint > 0
                                                  ? Images.UP
                                                  : Images.DOWN,
                                              width: UIHelper.size(12),
                                              height: UIHelper.size(12),
                                              color:
                                                  matchHistory.getMyTeamPoint >
                                                          0
                                                      ? GREEN_TEXT
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    : StatusIndicator(
                                        status: matchHistory.getStatus,
                                        statusName: matchHistory.getStatusName,
                                      ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: matchHistory.getOpponentTeam != null
                                ? InkWell(
                                    onTap: () => Navigation.instance
                                        .navigateTo(TEAM_DETAIL,
                                            arguments:
                                                matchHistory.getOpponentTeam),
                                    child: Hero(
                                      tag: matchHistory.getOpponentTeam.id,
                                      child: CustomizeImage(
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
