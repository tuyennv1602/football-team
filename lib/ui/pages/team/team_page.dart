import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
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
                onTap: () => Routes.routeToCreateGroup(context),
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
                onTap: () => Routes.routeToRequestMember(context),
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

  Widget _buildTeamMember(BuildContext context, Team team) {
    List<Widget> _children = [];
    if (team.manager != Provider.of<User>(context).id) {
      _children.addAll([
        ItemOptionWidget(
          Images.MEMBER,
          'Thành viên',
          iconColor: Colors.green,
          onTap: () => Routes.routeToMember(context),
        ),
        LineWidget(),
      ]);
    }
    return Column(
        children: _children
          ..addAll([
            ItemOptionWidget(
              Images.SCHEDULE,
              'Lịch thi đấu',
              iconColor: Colors.deepOrange,
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.MATCH_HISTORY,
              'Lịch sử thi đấu',
              iconColor: Colors.lightGreen,
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
            ItemOptionWidget(
              Images.INVITE,
              'Mời bạn bè vào đội',
              iconColor: Colors.indigoAccent,
            ),
            LineWidget(),
            ItemOptionWidget(
              Images.LEAVE_TEAM,
              'Rời đội bóng',
              iconColor: Colors.blueGrey,
            ),
            LineWidget(),
          ]));
  }

  Widget _buildTeamManager(BuildContext context, Team team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: UIHelper.size20,
              left: UIHelper.size10,
              right: UIHelper.size10,
              bottom: UIHelper.size10),
          child: Text(
            'Quản trị đội bóng',
            style: textStyleSemiBold(color: PRIMARY),
          ),
        ),
        LineWidget(),
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
          iconColor: Colors.blueAccent,
          onTap: () => Routes.routeToFindMatching(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.MEMBER_MANAGE,
          'Quản lý thành viên & yêu cầu',
          iconColor: Colors.amberAccent,
          onTap: () => Routes.routeToMemberManager(context),
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
      ],
    );
  }

  Widget _buildHeaderWidget(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.size15, vertical: UIHelper.size10),
      child: Row(
        children: <Widget>[
          ImageWidget(
              source: team.logo,
              placeHolder: Images.DEFAULT_LOGO,
              size: UIHelper.size(80)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    team.bio,
                    style: textStyleRegular(size: 16),
                  ),
                  Divider(
                    height: UIHelper.size10,
                    color: LINE_COLOR,
                  ),
                  Text('Xếp hạng: ${team.rank} (${team.point} điểm)',
                      style: textStyleRegular()),
                  Row(
                    children: <Widget>[
                      Text('Đánh giá: ', style: textStyleRegular()),
                      team.rated
                          ? FlutterRatingBarIndicator(
                              rating: team.rating,
                              itemCount: 5,
                              itemSize: UIHelper.size15,
                              emptyColor: Colors.amber.withAlpha(90),
                            )
                          : Text('Chưa có đánh giá', style: textStyleRegular()),
                    ],
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
                                      EdgeInsets.only(top: UIHelper.size10),
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    _buildHeaderWidget(context, _team),
                                    UIHelper.verticalSpaceSmall,
                                    _buildTeamMember(context, _team),
                                    _team.manager ==
                                            Provider.of<User>(context).id
                                        ? _buildTeamManager(context, _team)
                                        : SizedBox()
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
                                    )),
                                    Container(
                                      height: UIHelper.size50,
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
                                              Radius.circular(UIHelper.size15),
                                          topRight:
                                              Radius.circular(UIHelper.size15),
                                        ),
                                      ),
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
