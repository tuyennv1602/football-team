import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/pages/team/search_team_page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/back_drop.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/team_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeamState();
  }
}

class _TeamState extends State<TeamPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<BackdropState> _backdropKey =
      GlobalKey<BackdropState>(debugLabel: 'Backdrop');

  Widget _buildEmptyTeam(BuildContext context) => BorderBackground(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => Routes.routeToCreateTeam(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.ADD_TEAM,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      'Thành lập đội bóng',
                      style: textStyleTitle(color: BLACK_TEXT),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Routes.routeToSearchTeam(
                    context, SEARCH_TYPE.REQUEST_MEMBER),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.ADD_REQUEST,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      'Tham gia đội bóng',
                      style: textStyleTitle(color: BLACK_TEXT),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildTeamOptions(BuildContext context, Team team) {
    List<Widget> _children = [];
    List<Widget> _manager = [];
    if (team.manager == Provider.of<User>(context).id) {
      _manager.addAll([
        ItemOptionWidget(
          Images.BOOKING,
          'Đặt sân bóng',
          iconColor: Colors.green,
          onTap: () => Routes.routeToSearchGround(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.FIND_MATCH,
          'Tìm đối tác',
          iconColor: Colors.red,
          onTap: () => Routes.routeToFindMatching(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.STACK,
          'Lời mời ghép đối',
          iconColor: Colors.lightBlue,
          onTap: () => Routes.routeToInviteRequest(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.MEMBER_MANAGE,
          'Yêu cầu gia nhập đội bóng',
          iconColor: Colors.green,
          onTap: () => Routes.routeToRequestMember(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.BUDGET,
          'Quản lý tài chính',
          iconColor: Colors.amber,
          onTap: () => Routes.routeToFinance(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.SETTING,
          'Thiết lập đội bóng',
          iconColor: Colors.orange,
          onTap: () => Routes.routeToSetupTeam(context),
        ),
      ]);
    }
    return Column(
      children: _children
        ..addAll(
          [
            ItemOptionWidget(
              Images.MEMBER,
              'Danh sách thành viên',
              iconColor: Colors.green,
              onTap: () =>
                  Routes.routeToMember(context, team.members, team.manager),
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.SCHEDULE,
              'Lịch thi đấu',
              iconColor: Colors.deepOrange,
              onTap: () => Routes.routeToMatchSchedule(context),
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.MATCH_HISTORY,
              'Lịch sử thi đấu',
              iconColor: Colors.lightGreen,
              onTap: () => Routes.routeToMatchHistory(context),
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.COMMENT,
              'Thảo luận',
              iconColor: Colors.cyan,
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.WALLET_IN,
              'Đóng quỹ đội bóng',
              iconColor: Colors.amber,
              onTap: () => Routes.routeToTeamFund(context),
            ),
            LineWidget(),
          ]
            ..addAll(_manager)
            ..addAll([
              ItemOptionWidget(
                Images.INVITE,
                'Mời bạn bè vào đội',
                iconColor: Colors.pinkAccent,
              ),
              LineWidget(),
              ItemOptionWidget(
                Images.LEAVE_TEAM,
                'Rời đội bóng',
                iconColor: Colors.blueGrey,
              ),
            ]),
        ),
    );
  }

  Widget _buildHeaderWidget(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIHelper.size15),
      child: Row(
        children: <Widget>[
          ImageWidget(
              source: team.logo,
              placeHolder: Images.DEFAULT_LOGO,
              size: UIHelper.size(90)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Điểm: ${team.point}',
                    style: textStyleRegularTitle(),
                  ),
                  Text(
                    'Xếp hạng: ${team.rank}',
                    style: textStyleRegularTitle(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Đánh giá: ',
                        style: textStyleRegularTitle(),
                      ),
                      RatingBarIndicator(
                        rating: team.rating,
                        itemCount: 5,
                        itemPadding: EdgeInsets.only(left: 2),
                        itemSize: UIHelper.size25,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: UIHelper.size15,
                    color: LINE_COLOR,
                  ),
                  Align(
                    child: Text(
                      '\" ${team.bio} \"',
                      textAlign: TextAlign.center,
                      style: textStyleItalic(size: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTeam(BuildContext context, List<Team> teams,
          Future onChangeTeam(Team team)) =>
      ListView.separated(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (c, index) {
            var _team = teams[index];
            return InkWell(
              onTap: () {
                onChangeTeam(_team);
                _backdropKey.currentState.toggleFrontLayer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.size15, vertical: UIHelper.size10),
                child: Row(
                  children: <Widget>[
                    ImageWidget(
                      source: _team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                      child: Text(
                        _team.name,
                        style: textStyleRegularTitle(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (c, index) => LineWidget(),
          itemCount: teams.length);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<TeamViewModel>(
        model: TeamViewModel(
            authServices: Provider.of(context),
            teamServices: Provider.of(context),
            api: Provider.of(context)),
        onModelReady: (model) async {
          var resp = await model.refreshToken();
          if (!resp.isSuccess) {
            UIHelper.showSimpleDialog(resp.getErrorMessage,
                onTap: () => Routes.routeToLogin(context));
          }
        },
        builder: (context, model, child) {
          var _teams = model.teams;
          var _team = Provider.of<Team>(context);
          var _hasGroup = _team != null;
          return Column(
            children: <Widget>[
              _hasGroup
                  ? SizedBox()
                  : AppBarWidget(
                      centerContent: Text(
                        'Đội bóng',
                        textAlign: TextAlign.center,
                        style: textStyleTitle(),
                      ),
                    ),
              Expanded(
                child: model.busy
                    ? BorderBackground(
                        child: LoadingWidget(),
                      )
                    : _hasGroup
                        ? Container(
                            padding: EdgeInsets.only(top: UIHelper.paddingTop),
                            color: PRIMARY,
                            child: Backdrop(
                              key: _backdropKey,
                              color: Colors.white,
                              backTitle: Align(
                                child: Text(
                                  'Chọn đội bóng',
                                  style: textStyleTitle(),
                                ),
                              ),
                              frontLayer: Container(
                                color: Colors.white,
                                child: ListView(
                                  padding:
                                      EdgeInsets.only(top: UIHelper.size15),
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    _buildHeaderWidget(context, _team),
                                    UIHelper.verticalSpaceSmall,
                                    _buildTeamOptions(context, _team),
                                  ],
                                ),
                              ),
                              backLayer: BorderBackground(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildSelectTeam(
                                        context,
                                        _teams,
                                        (team) async {
                                          UIHelper.showProgressDialog;
                                          await model.changeTeam(team);
                                          UIHelper.hideProgressDialog;
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: UIHelper.size50,
                                      width: UIHelper.screenWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3,
                                            // has the effect of softening the shadow
                                            offset: Offset(
                                              0, // horizontal, move right 10
                                              -1, // vertical, move down 10
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(UIHelper.size20),
                                          topRight:
                                              Radius.circular(UIHelper.size20),
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                              frontTitle: Align(
                                child: Text(
                                  _team.name,
                                  style: textStyleTitle(),
                                ),
                              ),
                            ),
                          )
                        : _buildEmptyTeam(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
