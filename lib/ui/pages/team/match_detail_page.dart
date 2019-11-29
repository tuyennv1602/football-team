import 'package:flutter/material.dart';
import 'package:myfootball/models/match_history.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_member.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/matching_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchDetailPage extends StatelessWidget {
  final MatchHistory matchHistory;

  MatchDetailPage({Key key, @required MatchHistory matchHistory})
      : matchHistory = matchHistory,
        super(key: key);

  Widget _buildTeamMembers(BuildContext context, List<Member> members) {
    if (members == null) return LoadingWidget();
    return members.length == 0
        ? EmptyWidget(message: 'Chưa có thành viên nào')
        : ListView.separated(
            padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
            itemBuilder: (c, index) => ItemMember(
                member: members[index], isCaptain: members[index].isManager),
            separatorBuilder: (c, index) => UIHelper.verticalIndicator,
            itemCount: members.length);
  }

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
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
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchingDetailViewModel>(
                model: MatchingDetailViewModel(api: Provider.of(context)),
                onModelReady: (model) {
                  model.getMyTeamMembers(1, team.id);
                  if (matchHistory.receiveTeam != null) {
                    model.getOpponentTeamMembers(
                        1, matchHistory.getOpponentTeam.id);
                  }
                },
                builder: (c, model, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    matchHistory.receiveTeam != null
                        ? InkWell(
                            onTap: () => NavigationService.instance
                                .navigateTo(TEAM_DETAIL,
                                    arguments: matchHistory.getOpponentTeam),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.size10,
                                  horizontal: UIHelper.size15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ImageWidget(
                                    source: matchHistory.getOpponentLogo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size40,
                                  ),
                                  UIHelper.horizontalSpaceMedium,
                                  Expanded(
                                    child: Text(
                                      matchHistory.getOpponentName,
                                      style: textStyleSemiBold(size: 18),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  Image.asset(
                                    Images.NEXT,
                                    width: UIHelper.size10,
                                    height: UIHelper.size10,
                                    color: LINE_COLOR,
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    ItemOptionWidget(
                      Images.CLOCK,
                      matchHistory.getFullPlayTime,
                      iconColor: Colors.blue,
                      rightContent: SizedBox(),
                    ),
                    ItemOptionWidget(
                      Images.MARKER,
                      matchHistory.groundName,
                      iconColor: Colors.green,
                      onTap: () => NavigationService.instance.navigateTo(
                          GROUND_DETAIL,
                          arguments: matchHistory.groundId),
                    ),
                    matchHistory.getRatio != null
                        ? ItemOptionWidget(
                            Images.FRAME,
                            'Tỉ lệ (thắng-thua) ${matchHistory.getRatio}',
                            iconColor: Colors.red,
                            rightContent: SizedBox(),
                          )
                        : SizedBox(),

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
                                      _buildTeamMembers(
                                          context, model.myTeamMembers),
                                      _buildTeamMembers(
                                          context, model.opponentTeamMembers)
                                    ]),
                                  ),
                                ],
                              ),
                            )
                          : _buildTeamMembers(context, model.myTeamMembers),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
