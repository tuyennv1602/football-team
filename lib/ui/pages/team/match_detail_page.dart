import 'package:flutter/material.dart';
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
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/matching_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchDetailPage extends StatelessWidget {
  final MatchSchedule _matchSchedule;

  MatchDetailPage({Key key, @required MatchSchedule matchSchedule})
      : _matchSchedule = matchSchedule,
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
                  if (_matchSchedule.receiveTeam != null) {
                    model.getOpponentTeamMembers(
                        1, _matchSchedule.getOpponentTeam.id);
                  }
                },
                builder: (c, model, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _matchSchedule.receiveTeam != null
                        ? InkWell(
                            onTap: () => NavigationService.instance
                                .navigateTo(TEAM_DETAIL,
                                    arguments: _matchSchedule.getOpponentTeam),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.size10,
                                  horizontal: UIHelper.size15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ImageWidget(
                                    source: _matchSchedule.getOpponentLogo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size40,
                                  ),
                                  UIHelper.horizontalSpaceMedium,
                                  Expanded(
                                    child: Text(
                                      _matchSchedule.getOpponentName,
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
                    LineWidget(),
                    ItemOptionWidget(
                      Images.CLOCK,
                      _matchSchedule.getFullPlayTime,
                      iconColor: Colors.blue,
                      rightContent: SizedBox(),
                    ),
                    LineWidget(),
                    ItemOptionWidget(
                      Images.MARKER,
                      _matchSchedule.groundName,
                      iconColor: Colors.green,
                      onTap: () => NavigationService.instance.navigateTo(
                          GROUND_DETAIL,
                          arguments: _matchSchedule.groundId),
                    ),
                    _matchSchedule.getRatio != null ? LineWidget() : SizedBox(),
                    _matchSchedule.getRatio != null
                        ? ItemOptionWidget(
                            Images.FRAME,
                            'Tỉ lệ (thắng-thua) ${_matchSchedule.getRatio}',
                            iconColor: Colors.red,
                            rightContent: SizedBox(),
                          )
                        : SizedBox(),
                    LineWidget(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: UIHelper.size15,
                          vertical: UIHelper.size10),
                      child: Text(
                        'Danh sách đăng ký thi đấu',
                        style: textStyleRegularTitle(),
                      ),
                    ),
                    Expanded(
                      child: _matchSchedule.receiveTeam != null
                          ? DefaultTabController(
                              length: 2,
                              child: Column(
                                children: <Widget>[
                                  TabBarWidget(
                                    titles: [
                                      team.name,
                                      _matchSchedule.getOpponentName
                                    ],
                                    height: UIHelper.size30,
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
