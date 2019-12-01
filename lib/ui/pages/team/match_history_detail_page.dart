import 'package:flutter/material.dart';
import 'package:myfootball/models/match_history.dart';
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
                          Text(
                            '${matchHistory.getMyTeamScore} - ${matchHistory.getOpponentTeamScore}',
                            textAlign: TextAlign.center,
                            style: textStyleBold(
                                size: 30,
                                color: matchHistory.isConfirmed
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                          Expanded(
                            child: ImageWidget(
                              source: matchHistory.getOpponentLogo,
                              placeHolder: Images.DEFAULT_LOGO,
                            ),
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
