import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/border_item.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/item_member.dart';
import 'package:myfootball/ui/widget/item_option.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/match_history_detail_viewmodel.dart';
import 'package:myfootball/viewmodel/match_schedule_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
            itemBuilder: (c, index) {
              var _member = members[index];
              return ItemMember(
                member: _member,
                isCaptain: _member.isCaptain,
                isManager: _member.isManager,
                onTap: () => NavigationService.instance
                    .navigateTo(USER_COMMENT, arguments: _member.userId),
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
    var team = Provider.of<Team>(context);
    var userId = Provider.of<User>(context).id;
    return Scaffold(
      body: BaseWidget<MatchScheduleDetailViewModel>(
        model: MatchScheduleDetailViewModel(
            api: Provider.of(context), matchSchedule: matchSchedule),
        onModelReady: (model) {
          model.getMyTeamMembers(matchSchedule.getMyTeam.id);
          if (matchSchedule.receiveTeam != null) {
            model.getOpponentTeamMembers(matchSchedule.getOpponentTeam.id);
          }
        },
        builder: (c, model, child) => Container(
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
                  imageName: Images.SHARE_2,
                  onTap: () async {
                    if (matchSchedule.getMyTeam.code == null) {
                      if (team != null && team.hasManager(userId)) {
                        var code =
                            await model.createCode(matchSchedule.getMyTeam.id);
                        if (code != null) {
                          Share.share(model.matchSchedule.getShareCode);
                        }
                      } else {
                        UIHelper.showSimpleDialog(
                            'Chưa có mã tham gia trận đấu. Vui lòng chờ đội trưởng tạo mã');
                      }
                    } else {
                      Share.share(model.matchSchedule.getShareCode);
                    }
                  },
                ),
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: UIHelper.size40),
                      child: BorderBackground(
                        child: Padding(
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
                              team.hasManager(userId) &&
                                      matchSchedule.getMyTeam.code != null
                                  ? ItemOptionWidget(
                                      Images.MEMBER_MANAGE,
                                      'Yêu cầu tham gia trận đấu',
                                      iconColor: Colors.teal,
                                      onTap: () => NavigationService.instance
                                          .navigateTo(REQUEST_JOIN_MATCH,
                                              arguments: matchSchedule.matchId),
                                    )
                                  : SizedBox(),
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.padding,
                                    vertical: UIHelper.size5),
                                child: Text(
                                  'Danh sách đăng ký thi đấu',
                                  style: textStyleSemiBold(),
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
                                                matchSchedule.getMyTeamName,
                                                matchSchedule.getOpponentName
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
                                    : _buildTeamMembers(
                                        context, model.myTeamMembers),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: UIHelper.size(90),
                      margin: EdgeInsets.symmetric(horizontal: UIHelper.size20),
                      child: BorderItemWidget(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () => NavigationService.instance
                                    .navigateTo(TEAM_DETAIL,
                                        arguments: matchSchedule.getMyTeam),
                                child: Hero(
                                  tag: 'team-${matchSchedule.getMyTeam.id}',
                                  child: ImageWidget(
                                    source: matchSchedule.getMyTeamLogo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: UIHelper.size25,
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(UIHelper.size5),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(UIHelper.size5),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Color(0xFF02DC37), PRIMARY],
                                      )),
                                  child: Text(
                                    '${matchSchedule.getShortPlayTime}',
                                    textAlign: TextAlign.center,
                                    style:
                                        textStyleSemiBold(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: UIHelper.size25,
                                  child: Text(
                                    matchSchedule.getRatio,
                                    style: textStyleItalic(
                                        size: 14, color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: matchSchedule.getOpponentTeam != null
                                  ? InkWell(
                                      onTap: () => NavigationService.instance
                                          .navigateTo(TEAM_DETAIL,
                                              arguments: matchSchedule
                                                  .getOpponentTeam),
                                      child: Hero(
                                        tag:
                                            'team-${matchSchedule.getOpponentTeam.id}',
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
      ),
    );
  }
}
