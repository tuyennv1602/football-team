import 'package:flutter/material.dart';
import 'package:myfootball/model/match_schedule.dart';
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
import 'package:provider/provider.dart';

class MatchScheduleDetailPage extends StatelessWidget {
  final MatchSchedule matchSchedule;

  MatchScheduleDetailPage({Key key, @required MatchSchedule matchSchedule})
      : matchSchedule = matchSchedule,
        super(key: key);

  Widget _buildTeamMembers(BuildContext context, List<Member> members) {
    if (members == null) return LoadingWidget();
    return members.length == 0
        ? EmptyWidget(message: 'Chưa có thành viên đăng ký')
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
                'Thông tin trận đấu',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => NavigationService.instance.goBack(),
              ),
              rightContent: AppBarButtonWidget(
                imageName: Images.NOTIFICATION,
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
                          model.getMyTeamMembers(
                              matchSchedule.matchId, team.id);
                          if (matchSchedule.receiveTeam != null) {
                            model.getOpponentTeamMembers(matchSchedule.matchId,
                                matchSchedule.getOpponentTeam.id);
                          }
                        },
                        builder: (c, model, child) => Padding(
                          padding: EdgeInsets.only(top: UIHelper.size50),
                          child: Column(
                            children: <Widget>[
                              ItemOptionWidget(
                                Images.STADIUM,
                                matchSchedule.groundName,
                                iconColor: Colors.green,
                                onTap: () => NavigationService.instance
                                    .navigateTo(GROUND_DETAIL,
                                        arguments: matchSchedule.groundId),
                              ),
                              matchSchedule.getRatio != null
                                  ? ItemOptionWidget(
                                      Images.RATIO,
                                      'Tỉ lệ (thắng-thua)   ${matchSchedule.getRatio}',
                                      iconColor: Colors.red,
                                      rightContent: SizedBox(),
                                    )
                                  : SizedBox(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UIHelper.padding,
                                      vertical: UIHelper.size10),
                                  child: Text(
                                    'Danh sách thi đấu',
                                    style: textStyleSemiBold(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: matchSchedule.receiveTeam != null
                                    ? DefaultTabController(
                                        length: 2,
                                        child: Column(
                                          children: <Widget>[
                                            TabBarWidget(
                                              titles: [
                                                team.name,
                                                matchSchedule.getOpponentName
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
                          Container(
                            padding: EdgeInsets.all(UIHelper.size5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(UIHelper.size10),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF02DC37), PRIMARY],
                                )),
                            child: Text(
                              '${matchSchedule.getShortPlayTime}',
                              textAlign: TextAlign.center,
                              style: textStyleSemiBold(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: matchSchedule.getOpponentTeam != null
                                ? InkWell(
                                    onTap: () => NavigationService.instance
                                        .navigateTo(TEAM_DETAIL,
                                            arguments:
                                                matchSchedule.getOpponentTeam),
                                    child: Hero(
                                      tag: matchSchedule.getOpponentTeam.id,
                                      child: ImageWidget(
                                        source: matchSchedule.getOpponentLogo,
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
